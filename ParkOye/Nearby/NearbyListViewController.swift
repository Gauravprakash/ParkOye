//
//  NearbyListViewController.swift
//  Travolution
//
//  Created by Navin on 2/22/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import Moya
import Alamofire
import RxSwift

class NearbyListViewController: UIViewController {
    @IBOutlet weak var btnClose: UIBarButtonItem!
    @IBOutlet weak var heightOfSearchList: NSLayoutConstraint!
    @IBOutlet weak var viewNearbyTypes: CardView!
    @IBOutlet weak var heightOfCollctionView: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var heightOfSearchTypes: NSLayoutConstraint!
    @IBOutlet weak var ViewShowList: CardView!
    @IBOutlet weak var colllectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var leftBarButton: UIBarButtonItem!
    
    var arrOfNearBy=[(String,String,String)]()
    var pangesture:UIPanGestureRecognizer!
    var latlng : (Double,Double)! = (0,0)
    var queryString : String!
    var typeOfList:String!
    var annot = [CustomAnnotation]()
    var nearbyQs: NearbyQs!
    var dictQs = [String:Any]()
    var nearbyList = [NearbyList]()
    let regionRadius: CLLocationDistance! = 4000
    let locationManager = CLLocationManager()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ViewShowList.isHidden = true
        self.btnClose.isEnabled      = false
        self.btnClose.tintColor    = UIColor.clear
        self.heightOfSearchList.constant = 0
        self.title = "SEARCH NEARBY"
        self.tableView.registerNibs(nibNames: ["NearbyCell"])
        if self.revealViewController() != nil {
            leftBarButton.target = self.revealViewController()
            leftBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        arrOfNearBy = [("Restaurant","restaurant","RESTAURANTNEAR"),("Bar","bar","BARNEAR"),("Shopping Mall","shopping_mall","SHOPPING"),("ATM","atm","ATM"),("Fuel station","gas_station","FUEL"),("Car Rental","car_rental","CAR")]
        mapView.delegate = self
        if #available(iOS 11.0, *) {
            mapView.register(CustomAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
        
        colllectionView.registerNibs(nibNames: ["NearbyCollectionViewCell"])
        let size:CGFloat = colllectionView.frame.size.width / 5
        let sizeh:CGFloat = size * CGFloat(arrOfNearBy.count / 4).rounded()
        //(self.view.frame.size.height/8) * CGFloat(roles.count / 2).rounded() + 10
        heightOfSearchTypes.constant = sizeh+120
        // heightOfSearchTypes.constant = sizeh
        
        
        pangesture = UIPanGestureRecognizer(target: self, action: #selector(swipe))
        tableView.addGestureRecognizer(pangesture)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 500
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    @objc func handleEverySecond() {
        if CLLocationManager.locationServicesEnabled() {
            // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
    }
    
    
    @objc func swipe(_ sender: UIPanGestureRecognizer) {
        let translation = sender.location(in: self.tableView)
        let velocity = sender.velocity(in: self.tableView)
        if sender.state == .began {
            self.tableView.center =  CGPoint(x: self.tableView.center.x , y: self.tableView.center.y)
        }else  if sender.state == UIGestureRecognizer.State.changed {
            self.tableView.center =  CGPoint(x: self.tableView.center.x , y: self.tableView.center.y + translation.y)
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                let ht = translation.y - self.tableView.frame.origin.y
                self.heightOfSearchList.constant = (self.view.frame.height + ht) - translation.y
                self.tableView.layoutIfNeeded()
            }, completion: nil)
            
        } else if sender.state == .ended || sender.state == .cancelled {
            if velocity.y < 0 {
                upWardDirection()
            }else if velocity.y > 0 {
                downWardDirection()
            }else if velocity.y == 0{
                if self.tableView.frame.origin.x > self.view.frame.height/2{
                    downWardDirection()
                }else{
                    upWardDirection()
                }
            }
        }
    }
    @IBAction func bookServices(_ sender: UIButton) {
        switch sender.tag{
        case 11:
         UIApplication.shared.open(URL(string:"https://m.uber.com/ul/?")!, options: [:], completionHandler: nil)

        case 12:
            UIApplication.shared.open(URL(string:"olacabs://app/launch?")!, options: [:], completionHandler: nil)

        default:
            break
        }
        
    }
    
    
    func upWardDirection(){
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.ViewShowList.isHidden = true
            //self.tableView.isHidden = false
            self.heightOfSearchList.constant = self.view.frame.height
            self.tableView.layoutIfNeeded()
            self.tableView.removeGestureRecognizer(self.pangesture)
        }, completion: nil)
    }
    func downWardDirection(){
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.ViewShowList.isHidden = false
            //self.tableView.isHidden = true
            self.heightOfSearchList.constant = 0
            self.tableView.layoutIfNeeded()
        }, completion: nil)
    }
    func callGoogleAPI() {
        self.showLoader(message: "Loading..")
        let dict = [String:Any]()
        TVAPIProviderNearby.request(.NEARBY(dict)) { event in
            switch event {
            case .success(let response):
                self.hideLoader()
                if let json = try? response.mapJSON() {
                    if let dictionary = (json as? [String: Any]), let list = dictionary["results"] as? [[String:Any]] {
                            self.nearbyList = list.compactMap({ NearbyList(fromDictionary: $0) })
                            self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                self.hideLoader {
                    AlertFactory.alert(caller: self, msg: error.localizedDescription)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    @IBAction func btnBarButtion_Action(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShowList_Action(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.ViewShowList.isHidden = true
            self.heightOfSearchList.constant = self.view.frame.size.height/2
            self.tableView.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func btnAction_Close(_ sender: UIBarButtonItem) {
        self.title = "SEARCH NEARBY"
        self.btnClose.isEnabled      = false
        self.btnClose.tintColor    = UIColor.clear
        self.mapView.removeAnnotations(self.annot)
        self.annot.removeAll()
        self.ViewShowList.isHidden = true
        self.viewNearbyTypes.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.heightOfSearchList.constant = 0
            self.tableView.layoutIfNeeded()
        }, completion: nil)
    }
   
    
    func callGoogleNearbyAPI(type:String,complition:@escaping (Bool) -> Void) {
        self.showLoader(message: "Loading \(type)...")
        TVAPIProviderNearby.request(.NEARBY(nearbyQs.toDictionary())) { event in
            switch event {
            case .success(let response):
                self.hideLoader()
                if let json = try? response.mapJSON() {
                    if let dictionary = (json as? [String: Any]) {
                        var lists = [NearbyList]()
                        if let list = dictionary["results"] as? [[String:Any]]{
                            for dic in list{
                                let value = NearbyList(fromDictionary: dic)
                                lists.append(value)
                            }
                            self.nearbyList = lists
                            if self.nearbyList.count > 0{
                            complition(true)
                            }else{
                                complition(false)
                            }
                        }
                    }
                }
                break
            case .failure(let error):
                self.hideLoader()
                complition(false)
                AlertFactory.alert(caller: self, msg: error.localizedDescription)
            }
        }
    }
}
extension NearbyListViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
       // print("locations = \(locValue.latitude) \(locValue.longitude)")
        latlng = (locValue.latitude,locValue.longitude)
        dictQs["location"] = "\(locValue.latitude)"+","+"\(locValue.longitude)"
        dictQs["radius"] = "4000"
       // self.mapView.removeAnnotations(self.selfAnnot)
       // self.selfAnnot.removeAll()
        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        let initialLocation = CLLocation(latitude: (CLLocationDegrees(latlng.0)), longitude: (CLLocationDegrees(latlng.1)))
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        
    }
}
extension NearbyListViewController : UICollectionViewDelegate,UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOfNearBy.count > 0 ? arrOfNearBy.count:0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyCollectionViewCell", for: indexPath) as! NearbyCollectionViewCell
        //cell.setupUI(role: roles[indexPath.item],selectedRole: selectedRole )
        cell.setupNearby(imageName: arrOfNearBy[indexPath.item].2, nearbyType: arrOfNearBy[indexPath.item].0)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // clickListener.clicked(indexPath: indexPath, data: roles[indexPath.item])
       // self.dismiss(animated: true, completion: nil)
        dictQs["type"] = "\(arrOfNearBy[indexPath.item].1)"
        typeOfList = "\(arrOfNearBy[indexPath.item].0)"
        self.title = typeOfList
        dictQs["key"] = "AIzaSyA0NAfksVB8Kc-Ks2YCnN2u2fWL0FSxIOU"
        //"AIzaSyA0NAfksVB8Kc-Ks2YCnN2u2fWL0FSxIOU"
        //"AIzaSyBrEJknC6R7yh5zzWKwfVoug3NrJC5LaZw"
        nearbyQs = NearbyQs(dictionary: dictQs)
        let  handlerBlock: ((Bool) -> Void) = { doneWork in
            if doneWork {
                //print("We've finished working, bruh")
               // self.performSegue(withIdentifier: "MapView", sender: self.arrOfNearBy[indexPath.row].0)
                self.btnClose.isEnabled      = true
                self.btnClose.tintColor    = UIColor.white
                self.ViewShowList.isHidden = true
                self.viewNearbyTypes.isHidden = true
                UIView.animate(withDuration: 0.5, delay: 0, animations: {
                    self.heightOfSearchList.constant = self.view.frame.size.height/2
                    self.tableView.layoutIfNeeded()
                }, completion: nil)
                self.mapView.removeAnnotations(self.annot)
                self.annot.removeAll()
                for index in ( 0..<self.nearbyList.count) {
                    if let lat = self.nearbyList[index].geometry.location.lat,let lng = self.nearbyList[index].geometry.location.lng{
                        let cord = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(lat)), longitude: CLLocationDegrees(Double(lng)))
                        self.annot.append( CustomAnnotation(title: self.nearbyList[index].name ?? "N/A", subTitle: self.nearbyList[index].vicinity ?? "N/A", coordinate: cord,placeId:self.nearbyList[index].placeId ?? "",type: self.typeOfList ?? ""))
                        self.mapView.addAnnotations(self.annot)
                    }
                }
               self.tableView.reloadData()
            }else{
                 AlertFactory.alert(caller: self, msg: "No Results Found.")
            }
        }
        callGoogleNearbyAPI(type:"\(arrOfNearBy[indexPath.item].0)",complition: handlerBlock)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizew:CGFloat = colllectionView.frame.size.width/5
        return CGSize(width: sizew, height: sizew)
    }
    func setViewProperties(anView:MKAnnotationView,image:UIImage)  {
        anView.image  = image
        anView.backgroundColor = UIColor.clear
        anView.canShowCallout = false
        anView.canShowCallout = true
        anView.calloutOffset = CGPoint(x: -5, y: 5)
        anView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
}
extension NearbyListViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearbyList.count > 0 ? self.nearbyList.count:0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let ht = self.nearbyList[indexPath.row].name.height(withConstrainedWidth: UIScreen.main.bounds.width - 20, font: UIFont.systemFont(ofSize: 18, weight: .black)) + self.nearbyList[indexPath.row].vicinity.height(withConstrainedWidth: UIScreen.main.bounds.width - 20, font: UIFont.systemFont(ofSize: 16, weight: .black))
        if ht < 100 {
            return 140
        }else{
            return ht+80
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyCell") as! NearbyCell
        //  cell.setupCell(data: self.nearbyList[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NearbyCell{
            cell.selectionStyle = .none
            cell.setupCell(data: self.nearbyList[indexPath.row])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if targetContentOffset.pointee.y < scrollView.contentOffset.y {
             //print("it's going up")
        } else {
            // print("it's going down")
            if (scrollView.contentOffset.y == 0.0) {
                downWardDirection()
                tableView.addGestureRecognizer(pangesture)
            }
        }
    }
}
extension NearbyListViewController: MKMapViewDelegate {
    
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        
        if annotation.discipline == "Restaurant"{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "Restaurant")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Restaurant")
            } else {
                anView?.annotation = annotation
            }
            //anView?.image = #imageLiteral(resourceName: "RestaurantMap")
            if let view = anView{
                self.setViewProperties(anView: view,image: #imageLiteral(resourceName: "RestaurantMap"))
            }
            return anView
        }else if annotation.discipline == "Bar"{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "Bar")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Bar")
            } else {
                anView?.annotation = annotation
            }
           // anView?.image = #imageLiteral(resourceName: "BarMap")
            if let view = anView{
                self.setViewProperties(anView: view,image: #imageLiteral(resourceName: "BarMap"))
            }
            return anView
        }else if annotation.discipline == "Shopping Mall"{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "Shopping Mall")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Shopping Mall")
            } else {
                anView?.annotation = annotation
            }
            //anView?.image = #imageLiteral(resourceName: "ShoppingMallMap")
            if let view = anView{
                self.setViewProperties(anView: view,image: #imageLiteral(resourceName: "ShoppingMallMap"))
            }
            return anView
        }else if annotation.discipline == "Fuel station"{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "Fuel station")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Fuel station")
            } else {
                anView?.annotation = annotation
            }
               // anView?.image = #imageLiteral(resourceName: "FuelMap")
            if let view = anView{
                self.setViewProperties(anView: view,image: #imageLiteral(resourceName: "FuelMap"))
            }
            return anView
        }else if annotation.discipline == "ATM"{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "ATM")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "ATM")
            } else {
                anView?.annotation = annotation
            }
               // anView?.image = #imageLiteral(resourceName: "AtmMap")
            if let view = anView{
                self.setViewProperties(anView: view,image: #imageLiteral(resourceName: "AtmMap"))
            }
            return anView
        }else if annotation.discipline == "Car Rental"{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "Car Rental")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Car Rental")
            } else {
                anView?.annotation = annotation
            }
           // anView?.image = #imageLiteral(resourceName: "carRentalMap")
            if let view = anView{
                self.setViewProperties(anView: view,image: #imageLiteral(resourceName: "carRentalMap"))
            }
            return anView
        }
        else{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "MyLocation")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MyLocation")
            } else {
                anView?.annotation = annotation
            }
            if let imgName = annotation.markerImage{
                anView?.image = UIImage(named: imgName)
            }
         return anView
        }
 
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! CustomAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

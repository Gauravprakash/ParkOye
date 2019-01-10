//
//  NearByHospitalsVC.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 20/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NearByHospitalsVC: UIViewController {
@IBOutlet weak var tableView: UITableView!

@IBOutlet weak var mapView: MKMapView!
let regionRadius: CLLocationDistance! = 4000
let locationManager = CLLocationManager()
var pangesture:UIPanGestureRecognizer!
var nearbyList = [NearbyList]()
var dictQs = [String:Any]()
var annot = [CustomAnnotation]()
var latlng : (Double,Double)! = (0,0)
var nearbyQs: NearbyQs!
var tupleSource = ("Hospital","hospital")
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if #available(iOS 11.0, *) {
            mapView.register(CustomAnnotation.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
        tableView.registerNibs(nibNames: ["NearbyCell"])
        self.title =  tupleSource.0
        pangesture = UIPanGestureRecognizer(target: self, action: #selector(swipe))
        tableView.addGestureRecognizer(pangesture)
        setUserLocation()
       }
    func setUserLocation(){
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 500
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func upWardDirection(){
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            //self.heightOfSearchList.constant = self.view.frame.height
            self.tableView.layoutIfNeeded()
            self.tableView.removeGestureRecognizer(self.pangesture)
        }, completion: nil)
    }
    func downWardDirection(){
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            //self.tableView.isHidden = true
            //self.heightOfSearchList.constant = 0
            self.tableView.layoutIfNeeded()
        }, completion: nil)
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
                //self.heightOfSearchList.constant = (self.view.frame.height + ht) - translation.y
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
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func setViewProperties(anView:MKAnnotationView,image:UIImage)  {
        anView.image  = image
        anView.backgroundColor = UIColor.clear
        anView.canShowCallout = false
        anView.canShowCallout = true
        anView.calloutOffset = CGPoint(x: -5, y: 5)
        anView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    func callGoogleNearbyAPI(type:String) {
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
                           UIView.animate(withDuration: 0.5, delay: 0, animations: {

                                }, completion: nil)
                                self.mapView.removeAnnotations(self.annot)
                                self.annot.removeAll()
                                for index in ( 0..<self.nearbyList.count) {
                                    if let lat = self.nearbyList[index].geometry.location.lat,let lng = self.nearbyList[index].geometry.location.lng{
                                        let cord = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(lat)), longitude: CLLocationDegrees(Double(lng)))
                                        self.annot.append( CustomAnnotation(title: self.nearbyList[index].name ?? "N/A", subTitle: self.nearbyList[index].vicinity ?? "N/A", coordinate: cord,placeId:self.nearbyList[index].placeId ?? "",type: "Hospital"))
                                        self.mapView.addAnnotations(self.annot)
                                    }
                                }
                                self.tableView.reloadData()
                            }else{
                               
                            }
                        }
                    }
                }
                break
            case .failure(let error):
                self.hideLoader()
                AlertFactory.alert(caller: self, msg: error.localizedDescription)
            }
        }
    }
}

extension NearByHospitalsVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nearbyList.count > 0 ? self.nearbyList.count : 0
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
        } else {
            if (scrollView.contentOffset.y == 0.0) {
                downWardDirection()
                tableView.addGestureRecognizer(pangesture)
            }
        }
    }
}


extension NearByHospitalsVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        // print("locations = \(locValue.latitude) \(locValue.longitude)")
        latlng = (locValue.latitude,locValue.longitude)
        dictQs["location"] = "\(locValue.latitude)"+","+"\(locValue.longitude)"
        dictQs["radius"] = "4000"
        dictQs["type"] = "hospital"
        dictQs["key"] = "AIzaSyA0NAfksVB8Kc-Ks2YCnN2u2fWL0FSxIOU"
        nearbyQs = NearbyQs(dictionary: dictQs)
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        let initialLocation = CLLocation(latitude: (CLLocationDegrees(latlng.0)), longitude: (CLLocationDegrees(latlng.1)))
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        self.callGoogleNearbyAPI(type: "Hospital")
        
}
}

extension NearByHospitalsVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        if annotation.discipline == "Hospital"{
            var anView = mapView.dequeueReusableAnnotationView(withIdentifier: "Hospital")
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Hospital")
            } else {
                anView?.annotation = annotation
            }
            //anView?.image = #imageLiteral(resourceName: "RestaurantMap")
            if let view = anView{
                self.setViewProperties(anView: view,image: #imageLiteral(resourceName: "HOSPITAL"))
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

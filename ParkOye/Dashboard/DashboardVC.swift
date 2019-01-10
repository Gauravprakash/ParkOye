//
//  DashboardVC.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 01/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import Moya

class DashboardVC: UIViewController {
@IBOutlet weak var menuButton: UIBarButtonItem!
@IBOutlet weak var mapView: MKMapView!
@IBOutlet weak var priceValue: UILabel!
@IBOutlet weak var availability: UILabel!
@IBOutlet weak var priceView: UIView!
var type:HomeScreenType! = HomeScreenType.DEFAULT
var disposeBag = DisposeBag()
let locationManager = CLLocationManager()
let annotation =  MKPointAnnotation()
var latlng : (String,String) = ("","")

override func viewDidLoad() {
        super.viewDidLoad()
        if  self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    priceView.backgroundColor = UIColor(rgb: 0xF4F5F6)
    annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: Double(Theme.Strings.latValue)!)!, longitude: CLLocationDegrees(exactly: Double(Theme.Strings.longValue)!)!)
    mapView.addAnnotation(annotation)
    setUpTheme()
    setUserLocation()
    switch type!{
    case .DEFAULT:
        self.availability.text = "..."
        self.showLoader(message: "fetching value ..")
        self.getDlfData()
    case .SHARE:
        let available = Availability.sharedInstance.getAvailabity()
        self.availability.text = available
        let textToShare = ["https://itunes.apple.com/us/app/mlcp-noida/id1444053588?ls=1&mt=8"]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRect.zero
        }
        else{activityViewController.popoverPresentationController?.sourceView = self.view}
        
        self.present(activityViewController, animated: true, completion: nil)
    case .HOME:
        let available = Availability.sharedInstance.getAvailabity()
        self.availability.text = available
    case .VALET:
        self.availability.text = "85"
        self.priceValue.text = "\("100".currencified) for First Two Hours"
    }
    
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
    
    func setUpTheme(){
        self.priceValue.text = "\(Theme.Strings.priceValue.currencified) for First Two Hours"
        let center = CLLocationCoordinate2D(latitude:CLLocationDegrees(exactly: Double(Theme.Strings.latValue)!)!, longitude: CLLocationDegrees(exactly: Double(Theme.Strings.longValue)!)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
    }
    @IBAction func navigateView(_ sender: UIButton) {
        var url = ""
        url = UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) ? "comgooglemaps://?saddr=&daddr=\(Theme.Strings.latValue ?? ""),\(Theme.Strings.longValue ?? "")&directionsmode=driving" : "http://maps.apple.com/maps?saddr=\(self.latlng.0 ?? ""),\(self.latlng.1 ?? "")&daddr=\(Theme.Strings.latValue ?? ""),\(Theme.Strings.longValue ?? "")"
        
        if #available(iOS 10.0, *) {
            if UIApplication.shared.canOpenURL(URL(string: url)!){
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }
            
        } else {
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    
    func getDlfData(){
        ParkingAPIProvider.rx.request(.DLFDATA).subscribe( {event in
            switch event{
            case .success(let response):
                let json = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String:Any]
                if let dictionary = json as? [String: Any]{
                    if let errorCode = dictionary["status"] as? Int, errorCode == 1{
                        do {
                            let decoder = JSONDecoder()
                            let dlfData = try decoder.decode(Dlf.self, from: response.data)
                            if let arr = dlfData.data, arr.count>0{
                                let data = dlfData.data?.last
                                if data?.availability?.intified() == 0{
                                self.hideLoader {
                                  let alertController = UIAlertController(title: Theme.appName, message: "Please check our Valet Service", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Valet", style: .default, handler: { [weak self] (alert) in
                                       self?.availability.text = "100"
                                       self?.priceValue.text = "40".description
                                    }))
                                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
                                        (alert: UIAlertAction!) -> Void in
                                    })
                                    alertController.addAction(cancelAction)
                                    }
                                }else{
                                    self.hideLoader(completion: {
                                        self.availability.text = data?.availability
                                        Availability.sharedInstance.setAvailabilityValue(value: data?.availability ?? "")
                                    })
                                }
                                
                            }
                          
                        }catch { print(error) }
                    }
                    else{
                        self.hideLoader(completion: {
                            self.view.makeToast(dictionary["message"] as? String)
                        })
                    }
                }
                else{
                    print("Incorrect format response")
                }
            case .error(let err):
                print(err.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
}

extension DashboardVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latlng = (locValue.latitude.description,locValue.longitude.description)
     
    }
}

class Availability{
var availability = ""
static let sharedInstance = Availability()

func setAvailabilityValue(value:String){
       availability = value
}
func getAvailabity() -> String{
        return availability
}
}






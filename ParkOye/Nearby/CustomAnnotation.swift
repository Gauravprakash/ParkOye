//
//  CustomAnnotation.swift
//  Travolution
//
//  Created by Navin on 2/27/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subTitle: String, coordinate: CLLocationCoordinate2D,placeId:String,type:String) {
        self.title = title
        self.locationName = subTitle
        self.coordinate = coordinate
        self.discipline = type
        super.init()
    }
     var subtitle: String? {
        return locationName
    }
    
    var markerImage: String?  {
        switch discipline {
        case "Restaurant":
            return "reastaurantIcon.png"
        case "Bar":
            return "barIcon.png"
        case "Shopping Mall":
            return "shopingMall.png"
        case "ATM":
            return "atmIcon.png"
        case "Fuel station":
            return "petrolPump.png"
        case "Car Rental":
            return "carRentalIcon.png"
        case "Cafe":
            return "cafeIcon.png"
        case "Hospital":
            return "hospital.png"
        case "Doctor":
            return "doctorIcon.png"
        
        default:
            return "current-location.png"
        }
    }
    var imageName: String? {
        if discipline == "Sculpture" { return "Statue" }
        return "Flag"
    }
    
   
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

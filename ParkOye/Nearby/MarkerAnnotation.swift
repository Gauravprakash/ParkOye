//
//  MarkerAnnotation.swift
//  Travolution
//
//  Created by Navin on 2/28/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
class MarkerAnnotation: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
           // markerTintColor = customAnnotation.markerImage
            //      glyphText = String(artwork.discipline.first!)
            if let imageName = customAnnotation.markerImage {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        }
    }
    
}

class CustomAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "Maps-icon"), for: UIControl.State())
            rightCalloutAccessoryView = mapsButton
            //      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = customAnnotation.markerImage {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = customAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
    
}

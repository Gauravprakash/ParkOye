//
//  NearbyCell.swift
//  Travolution
//
//  Created by Navin on 2/22/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
class NearbyCell: UITableViewCell {
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var topNearby: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewBack: CardView!
    @IBOutlet weak var imageNearby: UIImageView!
    @IBOutlet weak var lblNearByType: UILabel!
    
    func setupCell(data:NearbyList){
         self.topNearby.constant = 5
        self.lblName.text = data.name
         self.lblNearByType.text = data.vicinity
        var ratingValue = ""
        if let ratingVal = data.rating, ratingVal > 0{
            let rating:Int = Int(ratingVal)
            for _ in 0..<rating{
                ratingValue.append("★")
            }
        }
        if ratingValue.isThere() {
            lblRating.text = ratingValue
        }else{
            lblRating.text = "No rating available"
        }
        
        loadFirstPhotoForPlace(placeID: data.placeId)
    }
    func loadFirstPhotoForPlace(placeID: String) {
        if !placeID.isEmpty {
            if let cachedImage = self.imageNearby.load(fileName: placeID){
                self.imageNearby.image = cachedImage
            }else{
                GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
                    if let error = error {
                        // TODO: handle the error.
                        print("Error: \(error.localizedDescription)")
                    } else {
                        if let firstPhoto = photos?.results.first {
                            self.loadImageForMetadata(photoMetadata: firstPhoto,placeId:placeID )
                        }
                    }
                }
            }
        }else{
            self.imageNearby.image = nil;
        }
    }
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, placeId:String) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, constrainedTo: self.imageNearby.frame.size, scale: 1.0) {
            (photo, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.imageNearby.image = photo;
                self.imageNearby.save(image: photo!, filename: placeId) // TODO: handle the nullability.
            }
        }
    }
}

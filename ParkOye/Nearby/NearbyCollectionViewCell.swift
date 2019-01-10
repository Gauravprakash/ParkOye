//
//  NearbyCollectionViewCell.swift
//  Travolution
//
//  Created by Navin on 3/5/18.
//  Copyright © 2018 Zillious Solutions. All rights reserved.
//

import UIKit

class NearbyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    func setupNearby(imageName: String,nearbyType:String){
        lblTitle.text = nearbyType
        imgView.image = UIImage(named: imageName)
        
    }
}

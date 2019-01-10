//
//  CardView.swift
//  Travolution
//
//  Created by Hemant Singh on 25/07/17.
//  Copyright © 2017 Zillious Solutions. All rights reserved.
//

import UIKit


@IBDesignable
class CardView: UIView {
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    
    override func layoutSubviews() {
        layer.cornerRadius = 4
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 4)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2);
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
    
}

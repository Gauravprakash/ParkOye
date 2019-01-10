//
//  StringExt.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 17/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
extension String{
var currencified: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let priceAsNumber = NSNumber(value: self.intified())
        let formattedPrice = formatter.string(from: priceAsNumber) ?? self
        return "₹ " + formattedPrice
    }
func isValidEmail() -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: self)
}
func intified() -> Int {
        guard let num =  Int.init(self.replacingOccurrences(of: ",", with: ""))
            else {
                return 0
        }
        return num
    }

func isThere() -> Bool{
        if self.count > 0 {
            return true
        }
        return false
    }
func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return ceil(boundingBox.height)
        
}
}



//
//  UIAlertControllerExt.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 22/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

extension UIAlertController{
    public func show(animated:Bool = true, vibrate:Bool = false, style:UIBlurEffectStyle? = nil,completion: (() -> ())? = nil ){
        if let style = style{
            for subview in view.allSubViewsOf(type: UIVisualEffectView.self) {
                subview.effect = UIBlurEffect(style: style)
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
        }
        if vibrate{
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }

    func addAction(image:UIImage? = nil , title: String, color: UIColor? = nil, style: UIAlertActionStyle = .default, isEnabled:Bool = true, completionHandler:((UIAlertAction) -> ())? = nil ){
        let action = UIAlertAction(title: title, style: style, handler: completionHandler)
        action.isEnabled = true
        if let image = image{
            action.setValue(image, forKey: "image")
        }
        if let color = color{
              action.setValue(color, forKey: "titleTextColor")
        }
        addAction(action)
    }


}




extension UIView{
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

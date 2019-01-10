//
//  ViewControllerExt.swift
//  ThiqahDelivery
//
//  Created by Gaurav Prakash on 17/08/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import UIKit
import DZNEmptyDataSet


extension UIViewController{
    var activityIndicatorTag: Int { return 999999 }
    func showLoader(message: String = "Loading...", completion: @escaping (() -> ())){
        DispatchQueue.main.async {
            let loader: DialogLoaderViewController = DialogLoaderViewController()
            loader.providesPresentationContextTransitionStyle = true
            loader.definesPresentationContext = true
            loader.modalPresentationStyle = .overCurrentContext
            self.present(loader, animated: true, completion: {
                completion()
            })
        }
    }
    
    func showLoader(message: String = "Loading..."){
        DispatchQueue.main.async {
            let loader: DialogLoaderViewController = DialogLoaderViewController()
            loader.providesPresentationContextTransitionStyle = true
            loader.definesPresentationContext = true
            loader.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
            self.present(loader, animated: true, completion: nil)
        }
    }
    func hideLoader(){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func hideLoader(completion: @escaping (() -> ())){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: {
                completion()
            })
        }
    }
    
    func startActivityIndicator(
        style: UIActivityIndicatorViewStyle = .whiteLarge,
        location: CGPoint? = nil) {
        
        let loc = location ?? self.view.center
        DispatchQueue.main.async {
            
            //Create the activity indicator
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: style)
            //Add the tag so we can find the view in order to remove it later
            
            activityIndicator.tag = self.activityIndicatorTag
            //Set the location
            activityIndicator.color = Theme.Color.primaryColor
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            //Start animating and add the view
            
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    func stopActivityIndicator() {
        DispatchQueue.main.async  {
            if let activityIndicator = self.view.subviews.filter(
                { $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setUpNavBar() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        imageView.contentMode = .scaleAspectFit
        imageView.image = Theme.Image.navigationView
        navigationItem.titleView = imageView
    }
}

extension UIViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "empty")
    }
    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "No Data Found.")
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Please Retry.")
}
}

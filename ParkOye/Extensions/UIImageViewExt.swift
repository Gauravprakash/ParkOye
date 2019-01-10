//
//  UIImageViewExt.swift
//  ParkOye
//
//  Created by Gaurav Prakash on 18/11/18.
//  Copyright © 2018 Gaurav Prakash. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RxSwift

extension UIImageView{
  var documentsUrl: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
    
    func setImage(from url: URL, withPlaceholder placeholder: UIImage? = nil) {
            if let filename = url.absoluteString.components(separatedBy: "/").last {
                if let img = load(fileName: filename) {
                    DispatchQueue.main.async {
                        self.image = img
                        return
                    }
                }
                else{
                    self.image = placeholder
                    Alamofire.request(url.absoluteString).responseData { (res) in
                        if let data = res.data {
                            let image = UIImage(data: data)
                            if image != nil {
                                // Save image.
                                self.save(image: image!, filename: filename)
                                DispatchQueue.main.async {
                                    self.image = image
                                }
                            }
                        }
                    }
                }
            }
    }

    public func save(image: UIImage, filename : String) {
        let fileURL = documentsUrl.appendingPathComponent(filename)
        let image = UIImage.jpegData(image)
//        let data = UIImageJPEGRepresentation(image, 1.0) //Set image quality here
//        do {
//            // writes the image data to disk
//            try data?.write(to: fileURL, options: .atomic)
//        } catch {
//            print("error:", error)
//        }
       

    }
    public func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            //            print("Error loading image : \(error)")
        }
        return nil
    }
}

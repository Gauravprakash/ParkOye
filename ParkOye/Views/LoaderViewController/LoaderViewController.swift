//
//  LoaderViewController.swift
//  Travolution
//
//  Created by Hemant Singh on 28/07/17.
//  Copyright © 2017 Zillious Solutions. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class LoaderViewController: UIViewController {
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var loadingTitleLabel: UILabel!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    let disposeBag = DisposeBag()
    var message = "Loading..."
    var loaderTitle: String = ""
    var image: UIImage?
    var completionCallback: ((Response?) -> Void)?
    
    fileprivate func setupUI() {
        loadingTitleLabel.text = loaderTitle
        loadingMessageLabel.text = message
        loadingImageView.image = image
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
//        self.view.backgroundColor = Theme.Colors.loaderBackgroundColor
//        loadingMessageLabel.textColor = Theme.primaryColor
//        loadingTitleLabel.textColor = Theme.primaryColorDark
//        cancelButton.setImage(#imageLiteral(resourceName: "ic_close").tint(with: .white), for: .normal)
//        backGroundImageView.image = Images.loaderBackImage
//        cancelButton.backgroundColor = Theme.accentColor
    }
     override func viewDidAppear(_ animated: Bool) {
//        setupUI()
//        let progressView = GMDCircularProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 80, height: 80)))
//        progressView.center = self.view.center
//        self.view.addSubview(progressView)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  TVTextField.swift
//  Zillious
//
//  Created by Hemant Singh on 29/06/17.
//  Copyright © 2017 Zillious Solutions. All rights reserved.
//

import Foundation
import UIKit
import Material

class TVTextField : ErrorTextField {
override func prepare(){
        super.prepare()
        self.placeholderActiveColor = .black
        self.placeholderNormalColor = .gray
        self.detailColor = .red
        self.dividerActiveColor = .black
        self.dividerNormalColor = .black
        self.detailVerticalOffset = 2
        self.placeholderVerticalOffset = 11
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textColor = .black
    }
    
}


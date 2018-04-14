//
//  RoundCornerButton.swift
//  PassCodeVIew
//
//  Created by Jasmin Pethani on 03/04/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import UIKit

@IBDesignable
class RoundCornerButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
    }
    
    @IBInspectable var cornerRadiusButton: CGFloat = 10 {
        didSet {
        	layer.cornerRadius = cornerRadiusButton
            layer.masksToBounds = true
        }
    }
    

}

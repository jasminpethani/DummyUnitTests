//
//  CustomKeyboard.swift
//  PassCodeVIew
//
//  Created by jasmin on 27/03/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import UIKit

class CustomKeyboard: UIView {
	
//	@IBOutlet weak var deleteBtn: UIButton!
	
	@IBAction func numberBtns(_ sender: Any) {
		let btn = sender as! UIButton
		print(btn.tag)
	}
	
	@IBAction func deleteButtonPressed(_ sender: Any) {
		
	}
	
	
}

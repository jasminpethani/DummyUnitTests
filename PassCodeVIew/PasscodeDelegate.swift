//
//  PasscodeProtocol.swift
//  PassCodeVIew
//
//  Created by jasmin on 23/03/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import Foundation


protocol PasscodeDelegate: class {
	func passcodeView(_ passcodeView: PassCodeViewContainer, withType passcodeType: PassCodeType)
	func actionOnSkipButton()

}

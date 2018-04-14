//
//  MockViewController.swift
//  PassCodeVIewTests
//
//  Created by Jasmin Pethani on 04/04/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import XCTest

@testable import PassCodeVIew

class MockViewController: ViewController, Mock {
	
	let callHandler: CallHandler
	
	override var traitCollection: UITraitCollection {
		let test_traitCollection = UITraitCollection(traitsFrom: [
			UITraitCollection(horizontalSizeClass: .compact),
			UITraitCollection(verticalSizeClass: .compact)
		])
		
		return test_traitCollection
	}
	
	init(_ testCases: XCTestCase) {
		callHandler = CallHandlerImpl(withTestCase: testCases)
		super.init(nibName: "MockVC", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func instanceType() -> MockViewController {
		return self
	}
	
	 
	override func passcodeView(_ passcodeView: PassCodeViewContainer, withType type: PassCodeType) {
		print("delegate_passcodeView()")
		callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: true)
	}
	
	override func actionOnSkipButton() {
		print("actionOnSkipButton()")
		callHandler.accept(nil, ofFunction: #function, atFile: #file, inLine: #line, withArgs: true)
	}
}

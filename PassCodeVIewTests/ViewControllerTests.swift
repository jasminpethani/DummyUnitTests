//
//  ViewControllerTests.swift
//  PassCodeVIewTests
//
//  Created by Jasmin Pethani on 04/04/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import XCTest
@testable import PassCodeVIew

class ViewControllerTests: XCTestCase {
	var sut: ViewController!
	var stuNavController: UINavigationController!
	var mockObject: MockViewController!
	
	
	func vc_storyboard() -> ViewController {
		let main = UIStoryboard(name: "Main", bundle: nil)
		stuNavController = main.instantiateViewController(withIdentifier: "navPasscodeVC") as! UINavigationController
		_ = stuNavController.view
		return stuNavController.topViewController as! ViewController
	}
	
	
	override func setUp() {
		super.setUp()
		mockObject = MockViewController(self)
		sut = vc_storyboard()
		_ = sut.view
		
		ViewController.shared = mockObject
	}
	
	override func tearDown() {
		sut = nil
		mockObject = nil
		super.tearDown()
	}
	
	func test_viewLoaded() {
 		XCTAssertTrue(sut.isViewLoaded)
	}
	
	func test_passcodeView() {
		XCTAssertNotNil(sut.passcodeView)
	}
	
	func test_invalidateClosure() {
		sut.setupPasscodeView(PassCodeType.confirmPasscode("123456", false))
		sut.viewDidLoad()
		sut.passcodeView.invalidClosure?()
		XCTAssertTrue(sut._isFunctionCalled)
	}
	
	func test_viewDidLayoutSubViews() {
		sut.viewDidLayoutSubviews()
		XCTAssertTrue(sut._isFunctionCalled)
	}
	
	func test_keyboardView() {
		// Setup
		mockObject.view = UIView()
		mockObject.setupPasscodeView(.newPassCode)
		mockObject.trailingConstriantPasscodeView = NSLayoutConstraint()
		
		// Assessment
		XCTAssertNil(mockObject.keyboard)
		sut.setOverrideTraitCollection(mockObject.traitCollection, forChildViewController: ViewController.shared)
		XCTAssertNotNil(mockObject.keyboard)
	}
	
	func test_traitCollection() {
		// Setup
		mockObject.view = UIView()
		mockObject.setupPasscodeView(.newPassCode)
		
		sut.setOverrideTraitCollection(sut.traitCollection, forChildViewController: sut)
		XCTAssertNil(sut.keyboard)
	}
	
	func test_actionOnSkipButton() {
		_ = mockObject.when().call(withReturnValue: mockObject.actionOnSkipButton()).thenDo { (args) in
			XCTAssertNotNil(args)
			XCTAssertTrue(args[0]! as! Bool)
		}
		sut.actionOnSkipButton()
	}
	
	func test_PasscodeDelegate_withNewPasscodeType() {
		_ = mockObject.when().call(withReturnValue: mockObject.passcodeView(sut.passcodeView, withType: .newPassCode)).thenDo({ (args) in
			XCTAssertNotNil(args)
			XCTAssertTrue(args[0]! as! Bool)
		})
		
		sut.passcodeView(sut.passcodeView, withType: PassCodeType.newPassCode)
	}
	
	func test_PasscodeDelegate_withConfirmPasscodeType_01() {
		_ = mockObject.when().call(withReturnValue: mockObject.passcodeView(sut.passcodeView, withType: PassCodeType.confirmPasscode("", true))).thenDo({ (args) in
			XCTAssertNotNil(args)
			XCTAssertTrue(args[0]! as! Bool)
		})
		
		sut.passcodeView(sut.passcodeView, withType: PassCodeType.confirmPasscode("", true))
	}
	
	func test_PasscodeDelegate_withConfirmPasscodeType_02() {
		_ = mockObject.when().call(withReturnValue: mockObject.passcodeView(sut.passcodeView, withType: PassCodeType.confirmPasscode("", false))).thenDo({ (args) in
			XCTAssertNotNil(args)
			XCTAssertTrue(args[0]! as! Bool)
		})
		
		sut.passcodeView(sut.passcodeView, withType: PassCodeType.confirmPasscode("", false))
	}
}

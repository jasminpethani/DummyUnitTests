//
//  PassCodeVIewTests.swift
//  PassCodeVIewTests
//
//  Created by Jasmin Pethani on 01/04/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import XCTest
@testable import PassCodeVIew

class PassCodeVIewTests: XCTestCase {
	
	var mockVC: ViewController!
	var navController : UINavigationController!
	
	
	override func setUp() {
		super.setUp()
		
		mockVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
		navController = UINavigationController(rootViewController: mockVC)
		_ = navController.view
		_ = mockVC.view
	}
	
    
	func test_compare_passcodes() {
		
		
		
 	}
}

//
//  ViewController.swift
//  PassCodeVIew
//
//  Created by jasmin on 23/03/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PasscodeDelegate {
	
	private var copyPasscode: String?
	var passcodeView: PassCodeViewContainer!
	var keyboard: CustomKeyboard!
	
	var trailingConstriantPasscodeView: NSLayoutConstraint!
	var constraintsForKeyboardLayout = [NSLayoutConstraint]()
	
	// Unit testing properties
	static var shared: ViewController!
	var _isFunctionCalled: Bool = false 
	
	
	
	func setupPasscodeView(_ passcodeType: PassCodeType) {
		passcodeView = PassCodeViewContainer.loadFromNib()
		passcodeView.translatesAutoresizingMaskIntoConstraints = false
		passcodeView.delegate = ViewController.shared
		passcodeView.type = passcodeType
		var titleForScreen = String()
		
		if case PassCodeType.newPassCode = passcodeType {
			titleForScreen = "Choose Passcode"
		} else {
			titleForScreen = "Re-Enter Passcode"
		}
		
		
		
		passcodeView.setupTitleAndDesc(titleForScreen, desc: "This is my description.")
		view.addSubview( passcodeView)
		
		// Autolayout anchors 
		 passcodeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		 passcodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		trailingConstriantPasscodeView =  passcodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		trailingConstriantPasscodeView.isActive = true
	}
	
	
	func setupKeyboard() {
		if  keyboard == nil {
			 keyboard =  passcodeView.keyboard
			 keyboard.backgroundColor = UIColor.yellow
			 keyboard.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview( keyboard)
			
			constraintsForKeyboardLayout = [
				 passcodeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				 keyboard.topAnchor.constraint(equalTo: view.topAnchor),
				 keyboard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
				 keyboard.leadingAnchor.constraint(equalTo:  passcodeView.trailingAnchor),
				 keyboard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				 keyboard.widthAnchor.constraint(equalTo:  passcodeView.widthAnchor)
			]
		}
		_isFunctionCalled = true
	}
	
	
	private func setupKeyboardLayoutLandscape(collection: UITraitCollection) {
		let vClass	= collection.verticalSizeClass
		let hClass = collection.horizontalSizeClass
		
		if (vClass == .compact && hClass == .regular) || (vClass == .compact && hClass == .compact) {
 			setupKeyboard()
			trailingConstriantPasscodeView.isActive = false
			NSLayoutConstraint.activate(constraintsForKeyboardLayout)
		} else {
            setupKeyboard()
			NSLayoutConstraint.deactivate(constraintsForKeyboardLayout)
			trailingConstriantPasscodeView.isActive = true
			 keyboard?.removeFromSuperview()
			 keyboard = nil
		}
	}
	
	// Life cycle methods
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: "ViewController", bundle: nil)
		ViewController.shared = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		ViewController.shared = self
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_isFunctionCalled = true
	}

	func doSomething() {
		print("Do something")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		
		
	
		if passcodeView != nil, case PassCodeType.confirmPasscode(_, _) = passcodeType {
			passcodeView.invalidClosure = doSomething
		}
		
		// first-time it's for newPasscode then for confirm passcode
		if navigationController?.childViewControllers.count == 1 {
			ViewController.shared.setupPasscodeView(.newPassCode)
		}
		_isFunctionCalled = true
	}
	
	private func gotoDashboard() {
		print("home button clicked")
		_isFunctionCalled = true
	}
	
	
	// ON rotation methods
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		ViewController.shared.setupKeyboardLayoutLandscape(collection: traitCollection)
	}
	
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		if UIDevice.current.userInterfaceIdiom == .phone {	ViewController.shared.setupKeyboardLayoutLandscape(collection: newCollection)
		}
	}
	
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		coordinator.animate(alongsideTransition: { (context) in
			ViewController.shared.passcodeView.focusOnTextField()
		}, completion:{ (context) in
			self.view.layoutIfNeeded()
		})
	}
	
	
	
	// MARK:- PasscodeDelegate methods

	func passcodeView(_ passcodeView: PassCodeViewContainer, withType type: PassCodeType) {
		switch type {
		case .newPassCode:
			if let confirmController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController {
				confirmController.setupPasscodeView(PassCodeType.confirmPasscode( passcodeView.copyPasscode, false))
				navigationController?.pushViewController(confirmController, animated: true)
				ViewController.shared._isFunctionCalled = true
			}
		case .confirmPasscode( _, let isPasscodeMatched):
			if isPasscodeMatched {
				ViewController.shared.gotoDashboard()
			} else {
				print("passcodes aren't matched")
			}
		}
	}
	
	func actionOnSkipButton() {
		ViewController.shared.gotoDashboard()
	}
	
}


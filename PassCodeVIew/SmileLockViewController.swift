//
//  SmileLockViewController.swift
//  PassCodeVIew
//
//  Created by jasmin on 30/03/18.
//  Copyright © 2018 jasmin. All rights reserved.
//

import UIKit
import SmileLock

class SmileLockViewController: UIViewController {
	
	@IBOutlet weak var topView: UIView!
   var passwordContainerView: PasswordContainerView!
	var stackView: UIStackView! {
		return view.viewWithTag(101) as! UIStackView
	}
	
	var importantLayoutConstraints: [NSLayoutConstraint]!
	var iPhoneLanscapeLayoutConstraints: [NSLayoutConstraint]!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		topView.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		// Default constriants
		NSLayoutConstraint.activate([
			topView.topAnchor.constraint(equalTo: view.topAnchor),
			topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
		
		// constriant helps in landscape and portrait
		importantLayoutConstraints = [
			topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.topAnchor.constraint(equalTo: topView.bottomAnchor),
			stackView.heightAnchor.constraint(equalTo: topView.heightAnchor)
		]
		
		iPhoneLanscapeLayoutConstraints = [
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: topView.trailingAnchor),
			topView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			topView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		]
		
		// smile-lock settings
		passwordContainerView = PasswordContainerView.create(in: stackView, digit: 6)
		passwordContainerView.delegate = self
		passwordContainerView.highlightedColor = .brown
		passwordContainerView.tintColor = .blue
		passwordContainerView.width = 250
	}
	
	private func iPhonePortraitLayout() {
		NSLayoutConstraint.deactivate(iPhoneLanscapeLayoutConstraints)
		NSLayoutConstraint.activate(importantLayoutConstraints)
	}
	
	private func iPhoneLandscapeLayout() {
		NSLayoutConstraint.deactivate(importantLayoutConstraints)
		NSLayoutConstraint.activate(iPhoneLanscapeLayoutConstraints)
	}
	
	
	private func checkTraitCollectionAndLayout(_ trait: UITraitCollection) {
		let hClass = trait.horizontalSizeClass
		let vClass = trait.verticalSizeClass
		
//		if UIDevice.current.userInterfaceIdiom == .phone {
			if (vClass == .compact && hClass == .compact) || (vClass == .compact && hClass == .regular) { // landscape
				iPhoneLandscapeLayout()
			} else { // portrait
				iPhonePortraitLayout()
			}
//		}
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		checkTraitCollectionAndLayout(traitCollection)
	}
	
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		checkTraitCollectionAndLayout(newCollection)
	}

}

extension SmileLockViewController: PasswordInputCompleteProtocol {
	
	func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
	}
	
	func passwordInputComplete(_ passwordContainerView: PasswordContainerView, input: String) {
		print("input completed -> \(input)")
		//handle validation wrong || success
	}
}

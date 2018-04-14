
import UIKit

class PassCodeViewContainer: UIView {
	// Outlets
	@IBOutlet  var dashes: [UIImageView]!
	@IBOutlet  var textFields: [UITextField]!
	@IBOutlet  weak var titleLabel: UILabel!
	@IBOutlet  weak var descLabel: UILabel!
	
	var type:PassCodeType = PassCodeType()
	weak var delegate: PasscodeDelegate?
	private let max_passcodeLength = 6
	var copyPasscode = String()
	
	var invalidClosure: (() -> Void)?
	
	var invalidAttempt: Int = 0  {
		didSet {
			if invalidAttempt == 10 {
				invalidClosure?()
			}
		}
	}
	
	
	
	
	
	private var currentTextField: UITextField!
	var passcode: [String] = []
	
	lazy var keyboard:CustomKeyboard! = {
		return Bundle.main.loadNibNamed(String(describing: CustomKeyboard.self), owner: nil, options: nil)![0] as! CustomKeyboard
	}()
	
	// MARK:- Life cycle methods
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		titleLabel.text = nil
		descLabel.text = nil
		
		currentTextField = UITextField(frame: CGRect.zero)
		currentTextField.delegate = self
		currentTextField.isSecureTextEntry = true
		currentTextField.keyboardType = .numberPad
		currentTextField.becomeFirstResponder()
		addSubview(currentTextField)
	}
	
	static func loadFromNib() -> PassCodeViewContainer {
		return Bundle.main.loadNibNamed(String(describing: PassCodeViewContainer.self), owner: nil, options: nil)![0] as! PassCodeViewContainer
	}
	
	func setupTitleAndDesc(_ title:String, desc: String) {
		titleLabel.text = title
		descLabel.text = desc
	}

	func clearTextFields() {
		currentTextField.text = nil
		dashes.forEach { $0.isHidden = false }
		textFields.forEach {	$0.text = nil }
		passcode.removeAll()
	}
	
	func focusOnTextField() { // uses only when it rotates
		currentTextField.becomeFirstResponder()
		
//		if UIDevice.current.orientation == .landscapeLeft ||  UIDevice.current.orientation == .landscapeRight {
//			currentTextField.inputView = keyboard
//		} else {
//			currentTextField.inputView = nil
//			currentTextField.keyboardType = .numberPad
//		}
	}
	
	// animations
	
	// Action methods
	@IBAction func skipButtonPressed(sender: UIButton) {
		delegate?.actionOnSkipButton()
	}
}


// MARK:- UITextFieldDelegate Delegate

extension PassCodeViewContainer: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if !string.isEmpty && passcode.count <= max_passcodeLength {
			passcode.append(string)
		}
		
		if passcode.count > 0 && passcode.count <= max_passcodeLength {
			textFields[passcode.count - 1].text = string // adding text into textfield
			if let imageView = viewWithTag(passcode.count), imageView is UIImageView { // imageview hide
				imageView.isHidden = !string.isEmpty
			}
			
			if string.isEmpty {
				passcode.removeLast()
			}
		}
		
		
		if passcode.count == max_passcodeLength {
			copyPasscode = passcode.joined()
			var customType:PassCodeType = .newPassCode
			
			if case PassCodeType.confirmPasscode(let oldPasscode, _) = type {
				let isMatched = copyPasscode == oldPasscode
				if !isMatched {
					invalidAttempt += 1
				}
				customType = PassCodeType.confirmPasscode(copyPasscode, isMatched)
			}
			
			delegate?.passcodeView(self, withType: customType)
		}
		return true
	}
}

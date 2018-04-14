

// passcode types

enum PassCodeType {

	
	case newPassCode
	case confirmPasscode(String, Bool)
	
	init() {
		self = .newPassCode
	}
}

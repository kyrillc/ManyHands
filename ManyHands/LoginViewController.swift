//
//  LoginViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 18/07/2022.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {

    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.overrideUserInterfaceStyle = .light
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.placeholder = "email@example.com"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = CGFloat(10)
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.overrideUserInterfaceStyle = .light
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = CGFloat(10)
        return textField
    }()
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = CGFloat(10)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()
    lazy var alternateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = CGFloat(10)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(alternateAction), for: .touchUpInside)
        return button
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Many Hands"
        label.font = UIFont.boldSystemFont(ofSize: 45)
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "Every product has a story to tell!"
        label.font = UIFont.italicSystemFont(ofSize: 16)
        return label
    }()

    private var isLoginUI: Bool = true {
        didSet {
            if isLoginUI {
                confirmButton.setTitle("Sign In", for: .normal)
                alternateButton.setTitle("Create an account", for: .normal)
            }
            else {
                confirmButton.setTitle("Register", for: .normal)
                alternateButton.setTitle("I already have an account", for: .normal)
            }
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        isLoginUI = false
        self.view.backgroundColor = .white
        addViews()
        setConstraints()
    }
    
    private func addViews(){
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(confirmButton)
        self.view.addSubview(alternateButton)
    }
    private func setConstraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(subtitleLabel.snp.top)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(usernameTextField.snp.top).offset(-35)
        }
        
        usernameTextField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.center.equalTo(self.view)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.top.equalTo(usernameTextField.snp.bottom).offset(5)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }

        alternateButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.top.equalTo(confirmButton.snp.bottom).offset(5)
        }
    }
    
    // MARK: - Actions

    @objc func alternateAction(){
        isLoginUI.toggle()
    }
    
    @objc func confirmAction(){
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        if (isUsernameValid(username: username) == false || isPasswordValid(password: password) == false){
            print("Username or password are not valid!")
            return
        }
        
        if isLoginUI {
            signIn(with: username!, password: password!)
        }
        else {
            register(with: username!, password: password!)
        }
    }
    
    // MARK: - Field Validation

    private func isUsernameValid(username:String?) -> Bool {
        return username?.isValidEmail() ?? false
    }
    private func isPasswordValid(password:String?) -> Bool {
        return password?.isValidPassword() ?? false
    }
    
    // MARK: - Firebase Authentication

    private func register(with username:String, password:String){
        Auth.auth().createUser(withEmail: username, password: password) { user, error in
            if let _error = error {
                print(_error.localizedDescription)
            }
            else {
                print("Registered!")
                self.dismiss(animated: true)
            }
        }
    }
    
    private func signIn(with username:String, password:String){
        Auth.auth().signIn(withEmail: username, password: password) { user, error in
            if let _error = error {
                print(_error.localizedDescription)
                if let errorCode = AuthErrorCode.Code(rawValue: _error._code) {
                    switch errorCode {
                    case .invalidEmail : print("Invalid Email")
                    /*case .emailAlreadyInUse:
                        <#code#>
                    case .wrongPassword:
                        <#code#>
                    case .accountExistsWithDifferentCredential:
                        <#code#>
                    case .networkError:
                        <#code#>
                    case .credentialAlreadyInUse:
                        <#code#>
                    case .weakPassword:
                        <#code#>
                    case .invalidRecipientEmail:
                        <#code#>
                    case .missingEmail:
                        <#code#>
                    case .unauthorizedDomain:
                        <#code#>
                    
                    case .rejectedCredential:
                        <#code#>
                        
                    case .unverifiedEmail:
                        <#code#>
                        */
                    @unknown default:
                        print("An error occured")
                    }
                }
            }
            else {
                print("Signed In!")
                self.dismiss(animated: true)
            }
        }
    }

    // MARK: - Keyboard Events
    
    @objc func keyboardWillShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}

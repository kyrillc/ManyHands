//
//  LoginViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 18/07/2022.
//

import UIKit
import SnapKit
import FirebaseAuth
import RxSwift
import RxCocoa


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.overrideUserInterfaceStyle = .light
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = CGFloat(10)
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.overrideUserInterfaceStyle = .light
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = CGFloat(10)
        return textField
    }()
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.link
        button.layer.cornerRadius = CGFloat(10)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        return button
    }()
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    lazy var alternateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = CGFloat(10)
        button.layer.borderColor = UIColor.link.cgColor
        button.layer.borderWidth = 1.0
        button.setTitleColor(UIColor.link, for: .normal)
        button.addTarget(self, action: #selector(alternateAction), for: .touchUpInside)
        return button
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 45)
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.italicSystemFont(ofSize: 16)
        return label
    }()
    
    private let disposeBag = DisposeBag()
    private let loginViewModel = LoginViewModel()
    
    
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
        
        self.view.backgroundColor = .white
        
        addViews()
        setInitialUIProperties()
        setConstraints()
        setRxSwiftBindings()
                
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Initial Set-up
        
    private func addViews(){
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(confirmButton)
        self.view.addSubview(orLabel)
        self.view.addSubview(alternateButton)
    }
    
    private func setInitialUIProperties(){
        emailTextField.placeholder = loginViewModel.emailTextFieldPlaceholderString
        passwordTextField.placeholder = loginViewModel.passwordTextFieldPlaceholderString
        titleLabel.text = loginViewModel.titleString
        subtitleLabel.text = loginViewModel.subtitleString
        
        confirmButton.setTitle(loginViewModel.confirmButtonTitle, for: .normal)
        orLabel.text = loginViewModel.orLabelString
        alternateButton.setTitle(loginViewModel.alternateButtonTitle, for: .normal)
    }
    
    private func setConstraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(subtitleLabel.snp.top)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(emailTextField.snp.top).offset(-35)
        }
        
        emailTextField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.center.equalTo(self.view)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
        
        orLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.top.equalTo(confirmButton.snp.bottom).offset(5)
        }

        alternateButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.centerX.equalTo(self.view)
            make.top.equalTo(orLabel.snp.bottom).offset(5)
        }
    }
    
    private func setRxSwiftBindings(){
        emailTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.usernameTextPublishedSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passwordTextPublishedSubject).disposed(by: disposeBag)

        loginViewModel.isUserInputValid().bind(to: confirmButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isUserInputValid().map({ $0 ? 1.0 : 0.3 }).bind(to: confirmButton.rx.alpha).disposed(by: disposeBag)
    }
    
    // MARK: - TextFields Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTextField){
            passwordTextField.becomeFirstResponder()
        }
        else if (textField == passwordTextField && confirmButton.isEnabled){
            confirmAction()
        }
        return true
    }
    
    // MARK: - Actions

    @objc func alternateAction(){
        loginViewModel.toggleLoginUI { [weak self] confirmButtonTitle, alternateButtonTitle in
            self?.confirmButton.setTitle(confirmButtonTitle, for: .normal)
            self?.alternateButton.setTitle(alternateButtonTitle, for: .normal)
        }
    }
    
    @objc func confirmAction(){
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        loginViewModel.isLoginUI ? signIn(with: email!, password: password!) : register(with: email!, password: password!)
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
        Auth.auth().createUser(withEmail: username, password: password) { [weak self] user, error in
            if let _error = error {
                print(_error.localizedDescription)
                guard let _self = self else { return }
                AlertHelper.showErrorAlert(with: _error.localizedDescription, on: _self)
            }
            else {
                print("Registered!")
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func signIn(with username:String, password:String){
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] user, error in
            if let _error = error {
                print(_error.localizedDescription)
                guard let _self = self else { return }
                AlertHelper.showErrorAlert(with: _error.localizedDescription, on: _self)
            }
            else {
                print("Signed In!")
                self?.dismiss(animated: true)
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

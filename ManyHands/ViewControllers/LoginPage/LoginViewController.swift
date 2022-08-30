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
    private var loginViewModel = LoginViewModel()
    
    // MARK: - Init

    init(loginViewModel:LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
        
        self.view.backgroundColor = .systemBackground
        
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
        orLabel.text = loginViewModel.orLabelString
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
        // Bind textfields to loginViewModel's usernameTextPublishedSubject and passwordTextPublishedSubject
        emailTextField.rx.text.orEmpty.bind(to: loginViewModel.usernameTextPublishedSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: loginViewModel.passwordTextPublishedSubject).disposed(by: disposeBag)
        
        // Bind loginViewModel's isUserInputValid to confirmButton
        loginViewModel.isUserInputValid().bind(to: confirmButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isUserInputValid().map({ $0 ? 1.0 : 0.3 }).bind(to: confirmButton.rx.alpha).disposed(by: disposeBag)

        // Bind loginViewModel's confirmButtonTitlePublishedSubject and alternateButtonTitlePublishedSubject to button titles
        loginViewModel.confirmButtonTitleBehaviorSubject.bind(to: confirmButton.rx.title(for: .normal)).disposed(by: disposeBag)
        loginViewModel.alternateButtonTitleBehaviorSubject.bind(to: alternateButton.rx.title(for: .normal)).disposed(by: disposeBag)
                
        // Bind alternateButton tap to toggle loginViewModel's isLoginUI
        alternateButton.rx.tap.bind { [weak self] () in
            guard let self = self else { return }
            self.loginViewModel.toggleLoginUI()
        }.disposed(by: disposeBag)

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
    
    @objc func confirmAction(){
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        loginViewModel.confirmAction(with: email, password: password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.showErrorAlert(with: error.localizedDescription)
            case .success():
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

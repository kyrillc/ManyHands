//
//  RootViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 17/07/2022.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa


class RootViewController: UIViewController {
    
    var backgroundGradientView = UIView()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = CGFloat(10)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(signOutAction), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 45)
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.italicSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var productCodeTextField: UITextField = {
        let textField = UITextField()
        textField.overrideUserInterfaceStyle = .light
        textField.autocapitalizationType = .allCharacters
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = CGFloat(10)
        return textField
    }()
    
    lazy var productCodeEnterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.link
        button.layer.cornerRadius = CGFloat(10)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(checkProductAction), for: .touchUpInside)
        return button
    }()
    
    lazy var orLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var addProductButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = CGFloat(10)
        button.layer.borderColor = UIColor.link.cgColor
        button.layer.borderWidth = 1.0
        button.setTitleColor(UIColor.link, for: .normal)
        button.addTarget(self, action: #selector(addProductAction), for: .touchUpInside)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private let rootViewModel = RootViewModel()
    var authStateListener:NSObjectProtocol?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addViews()
        setBackgroundGradient()
        setInitialUIProperties()
        setConstraints()
        setRxSwiftBindings()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.authStateListener = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let _ = user {
                print("We have a user")
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                // let uid = user.uid
            }
            else {
                print("We don't have a user")
                self?.showLoginViewControllerIfNecessary()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.authStateListener != nil){
            Auth.auth().removeStateDidChangeListener(self.authStateListener!)
        }
    }
    
    // MARK: Initial Set-up

    private func addViews(){
        self.view.addSubview(backgroundGradientView)
        self.view.addSubview(signOutButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(productCodeTextField)
        self.view.addSubview(productCodeEnterButton)
        self.view.addSubview(orLabel)
        self.view.addSubview(addProductButton)
    }
    
    private func setBackgroundGradient(){
        // Create a gradient layer.
        let gradientLayer = CAGradientLayer()
        // Set the size of the layer to be equal to size of the display.
        gradientLayer.frame = view.bounds
        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
        // This example uses a Color Literal and a UIColor from RGB values.
        gradientLayer.colors = [#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor]
        // Rasterize this static layer to improve app performance.
        gradientLayer.shouldRasterize = true
        // Apply the gradient to the backgroundGradientView.
        backgroundGradientView.layer.addSublayer(gradientLayer)
    }
    
    private func setInitialUIProperties(){
        signOutButton.setTitle(rootViewModel.signOutButtonString, for: .normal)
        titleLabel.text = rootViewModel.titleString
        subtitleLabel.text = rootViewModel.subtitleString
        productCodeTextField.placeholder = rootViewModel.productCodeTextFieldPlaceHolderString
        productCodeEnterButton.setTitle(rootViewModel.productCodeEnterButtonString, for: .normal)
        orLabel.text = rootViewModel.orLabelString
        addProductButton.setTitle(rootViewModel.addProductButtonString, for: .normal)
    }
    
    private func setConstraints(){
        backgroundGradientView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.view)
        }
        
        signOutButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.topMargin.equalTo(self.view).offset(20)
            make.leadingMargin.equalTo(self.view).offset(10)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(subtitleLabel.snp.top)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(productCodeTextField.snp.top).offset(-35)
        }
        
        productCodeTextField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(250)
            make.center.equalTo(self.view)
        }

        productCodeEnterButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(250)
            make.centerX.equalTo(self.view)
            make.top.equalTo(productCodeTextField.snp.bottom).offset(5)
        }
        
        orLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.width.equalTo(250)
            make.centerX.equalTo(self.view)
            make.top.equalTo(productCodeEnterButton.snp.bottom).offset(5)
        }
        
        addProductButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(250)
            make.centerX.equalTo(self.view)
            make.top.equalTo(orLabel.snp.bottom).offset(5)
        }
    }
    
    private func setRxSwiftBindings(){
        productCodeTextField.rx.text.map { $0 ?? "" }.bind(to: rootViewModel.productCodeTextPublishedSubject).disposed(by: disposeBag)

        rootViewModel.isUserInputValid().bind(to: productCodeEnterButton.rx.isEnabled).disposed(by: disposeBag)
        rootViewModel.isUserInputValid().map({ $0 ? 1.0 : 0.5 }).bind(to: productCodeEnterButton.rx.alpha).disposed(by: disposeBag)
    }
    
    // MARK: - SignIn - SignOut
    
    func showLoginViewControllerIfNecessary(){
        let isLoggedIn = (Auth.auth().currentUser != nil)
        if isLoggedIn == false {
            let loginVC = LoginViewController()
            
            // Prevents user from dismissing the view by swiping down:
            loginVC.isModalInPresentation = true
            
            self.present(loginVC, animated: true)
        }
    }
    
    @objc func signOutAction() throws{
        print("signOutAction")
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
    
    // MARK: - Actions

    @objc func addProductAction(){
        print("addProductAction")
        //FirestoreDataHandler.addEntryToFirestore()
    }
    
    @objc func checkProductAction(){
        print("checkProductAction")
    }
    
    
}

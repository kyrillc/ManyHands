//
//  LoginViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift
import RxCocoa


class LoginViewModel {
    
    let emailTextFieldPlaceholderString = "email@example.com"
    let passwordTextFieldPlaceholderString = "Password"
    let titleString = Constants.appTitle
    let subtitleString = Constants.appSubtitle
    private let signInButtonString = "Sign In"
    private let registerButtonString = "Register"
    let orLabelString = "- OR -"
    private let switchToRegisterButtonString = "Create an account"
    private let switchToLoginButtonString = "I already have an account"

    
    let usernameTextPublishedSubject = PublishSubject<String>()
    let passwordTextPublishedSubject = PublishSubject<String>()
    
    let confirmButtonTitleBehaviorSubject = BehaviorSubject<String>(value: "")
    let alternateButtonTitleBehaviorSubject = BehaviorSubject<String>(value: "")

    let isLoginUIBehaviorRelay = BehaviorRelay<Bool>(value: true)
    
    private let disposeBag = DisposeBag()

    init() {
        
        // Set confirmButtonTitle depending on value of isLoginUI:
        isLoginUIBehaviorRelay.map({ [weak self] isLoginUI in
            guard let self = self else { return "" }
            return isLoginUI ? self.signInButtonString : self.registerButtonString
        }).bind(to: confirmButtonTitleBehaviorSubject).disposed(by: disposeBag)
        
        // Set alternateButtonTitle depending on value of isLoginUI:
        isLoginUIBehaviorRelay.map({ [weak self] isLoginUI in
            guard let self = self else { return "" }
            return isLoginUI ? self.switchToRegisterButtonString : self.switchToLoginButtonString
        }).bind(to: alternateButtonTitleBehaviorSubject).disposed(by: disposeBag)
        
    }
    
    func isUserInputValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextPublishedSubject.asObservable().startWith(""),
                                        passwordTextPublishedSubject.asObservable().startWith("")).map { username, password in
            
            return username.isValidEmail() && password.isValidPassword()
        }.startWith(false)
    }

}

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
    let titleString = "Many Hands"
    let subtitleString = "Every product has a story to tell!"
    let signInButtonString = "Sign In"
    let orLabelString = "- OR -"
    let registerButtonString = "Register"
    let switchToRegisterButtonString = "Create an account"
    let switchToLoginButtonString = "I already have an account"

    
    let usernameTextPublishedSubject = PublishSubject<String>()
    let passwordTextPublishedSubject = PublishSubject<String>()
    
    func isUserInputValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextPublishedSubject.asObservable().startWith(""),
                                        passwordTextPublishedSubject.asObservable().startWith("")).map { username, password in
            
            return username.isValidEmail() && password.isValidPassword()
        }.startWith(false)
    }
    
    private(set) var isLoginUI: Bool = true
    
    var confirmButtonTitle: String {
        if isLoginUI {
            return signInButtonString
        }
        else {
            return registerButtonString
        }
    }
    
    var alternateButtonTitle: String {
        if isLoginUI {
            return switchToRegisterButtonString
        }
        else {
            return switchToLoginButtonString
        }
    }
    
    func toggleLoginUI(handler: @escaping (_ confirmButtonTitle: String, _ alternateButtonTitle: String) -> Void) {
        isLoginUI.toggle()
        handler(self.confirmButtonTitle, self.alternateButtonTitle)
    }
    
    // Previous implementation when isLoginUI was in LoginViewController:
    
    //    private var isLoginUI: Bool = true {
    //        didSet {
    //            if isLoginUI {
    //                confirmButton.setTitle(signInButtonString, for: .normal)
    //                alternateButton.setTitle(switchToRegisterButtonString, for: .normal)
    //            }
    //            else {
    //                confirmButton.setTitle(registerButtonString, for: .normal)
    //                alternateButton.setTitle(switchToLoginButtonString, for: .normal)
    //            }
    //        }
    //    }

}

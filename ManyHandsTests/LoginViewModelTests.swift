//
//  LoginViewModelTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 20/07/2022.
//

import XCTest
import RxSwift

@testable import ManyHands

class LoginViewModelTests: XCTestCase {

    
    func test_Initial_State_Is_Login_UI() throws {
        let sut = LoginViewModel()
        
        XCTAssertTrue(sut.isLoginUIBehaviorRelay.value)
    }
    
    func test_IsLoginUIBehaviorRelay_Changes_Confirm_And_Alternate_Button_Titles() throws {
        let sut = LoginViewModel()

        XCTAssertEqual(try sut.confirmButtonTitleBehaviorSubject.value(), "Sign In")
        XCTAssertEqual(try sut.alternateButtonTitleBehaviorSubject.value(), "Create an account")
        
        sut.isLoginUIBehaviorRelay.accept(false)
        
        XCTAssertEqual(try sut.confirmButtonTitleBehaviorSubject.value(), "Register")
        XCTAssertEqual(try sut.alternateButtonTitleBehaviorSubject.value(), "I already have an account")
        
        sut.isLoginUIBehaviorRelay.accept(true)
        
        XCTAssertEqual(try sut.confirmButtonTitleBehaviorSubject.value(), "Sign In")
        XCTAssertEqual(try sut.alternateButtonTitleBehaviorSubject.value(), "Create an account")
    }
    
    func test_isUserInputValid() throws {
        let sut = LoginViewModel()
        
        let isUserInputValidSpy = ValueSpy<Bool>(sut.isUserInputValid())
        let usernameSpy = ValueSpy<String>(sut.usernameTextPublishedSubject.asObservable())
        let passwordSpy = ValueSpy<String>(sut.passwordTextPublishedSubject.asObservable())

        XCTAssertEqual(usernameSpy.values, [])
        XCTAssertEqual(passwordSpy.values, [])

        XCTAssertEqual(isUserInputValidSpy.values, [false, false])
        
        sut.usernameTextPublishedSubject.accept("test@test.com")
        XCTAssertEqual(usernameSpy.values, ["test@test.com"])
        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false])
        
        sut.passwordTextPublishedSubject.accept("Passw0rd")
        XCTAssertEqual(passwordSpy.values, ["Passw0rd"])
        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false, true])
        
        sut.passwordTextPublishedSubject.accept("Passw0")
        XCTAssertEqual(passwordSpy.values, ["Passw0rd", "Passw0"])
        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false, true, false])
        
        sut.passwordTextPublishedSubject.accept("Passw0rd")
        XCTAssertEqual(passwordSpy.values, ["Passw0rd", "Passw0", "Passw0rd"])
        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false, true, false, true])
        
        sut.usernameTextPublishedSubject.accept("test@test")
        XCTAssertEqual(usernameSpy.values, ["test@test.com", "test@test"])
        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false, true, false, true, false])
        
        sut.usernameTextPublishedSubject.accept("test@test.com")
        XCTAssertEqual(usernameSpy.values, ["test@test.com", "test@test", "test@test.com"])
        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false, true, false, true, false, true])
    }
    
    
    private class ValueSpy<T> {
        
        var values = [T]()
        let disposeBag = DisposeBag()
        
        init(_ observable:Observable<T>) {
            observable.subscribe { [weak self] newBoolValue in
                print("ValueSpy.newValue:\(newBoolValue)")
                self?.values.append(newBoolValue)
            } onError: { error in
                //
            } onCompleted: {
                //
            } onDisposed: {
                //
            }.disposed(by: disposeBag)

        }
        
    }
}

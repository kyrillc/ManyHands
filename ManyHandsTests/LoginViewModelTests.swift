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
        
        let spy = BoolValueSpy(sut.isUserInputValid())
                
        XCTAssertEqual(spy.values, [false, false])
        
        sut.usernameTextPublishedSubject.accept("test@test.com")
        XCTAssertEqual(spy.values, [false, false, false])
        
        sut.passwordTextPublishedSubject.accept("Passw0rd")
        XCTAssertEqual(spy.values, [false, false, false, true])
        
        sut.passwordTextPublishedSubject.accept("Passw0")
        XCTAssertEqual(spy.values, [false, false, false, true, false])
        
        sut.passwordTextPublishedSubject.accept("Passw0rd")
        XCTAssertEqual(spy.values, [false, false, false, true, false, true])
        
        sut.usernameTextPublishedSubject.accept("test@test")
        XCTAssertEqual(spy.values, [false, false, false, true, false, true, false])
        
        sut.usernameTextPublishedSubject.accept("test@test.com")
        XCTAssertEqual(spy.values, [false, false, false, true, false, true, false, true])
    }
    
    
    private class BoolValueSpy {
        
        var values = [Bool]()
        let disposeBag = DisposeBag()
        
        init(_ observable:Observable<Bool>) {
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

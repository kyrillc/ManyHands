//
//  LoginViewModelTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 20/07/2022.
//

import XCTest
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
    
}

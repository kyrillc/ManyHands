//
//  LoginViewControllerTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 20/07/2022.
//

import XCTest
@testable import ManyHands

class LoginViewControllerTests: XCTestCase {
    
    func test_Initial_UI_Properties_Are_Correct() throws{
        let sut = makeSUT()
        
        XCTAssertEqual(sut.emailTextField.placeholder, "email@example.com")
        XCTAssertEqual(sut.passwordTextField.placeholder, "Password")
        XCTAssertEqual(sut.titleLabel.text, "Many Hands")
        XCTAssertEqual(sut.subtitleLabel.text, "Every product has a story to tell!")
        XCTAssertEqual(sut.orLabel.text, "- OR -")
        XCTAssertEqual(sut.confirmButton.title(for: .normal), "Sign In")
        XCTAssertEqual(sut.alternateButton.title(for: .normal), "Create an account")
    }
    
    
    func makeSUT() -> LoginViewController {
        let sut = LoginViewController()
        sut.loadViewIfNeeded()
        return sut
    }

}

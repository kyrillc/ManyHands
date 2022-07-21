//
//  RootViewModelTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 21/07/2022.
//

import XCTest
@testable import ManyHands

class RootViewModelTests: XCTestCase {

    
    func test_ProductCode_Text_Is_Cleared_When_User_Signs_Out() throws {

        let sut = RootViewModel()
        let productCodeTextSpy = ValueSpy<String>(sut.productCodeTextPublishedSubject.asObservable())
        
        XCTAssertEqual(productCodeTextSpy.values, [])
        
        sut.productCodeTextPublishedSubject.onNext("This should be cleared after sign out")
        XCTAssertEqual(productCodeTextSpy.values, ["This should be cleared after sign out"])

        try sut.signOut()
        XCTAssertEqual(productCodeTextSpy.values, ["This should be cleared after sign out", ""])
    }
    
    func test_UserInput_Valid_When_5_Characters_Long() throws {

        let sut = RootViewModel()
        let productCodeTextSpy = ValueSpy<String>(sut.productCodeTextPublishedSubject.asObservable())
        let isUserInputValidSpy = ValueSpy<Bool>(sut.isUserInputValid())

        XCTAssertEqual(isUserInputValidSpy.values, [false, false])
        
        let five_Character_String = "12345"
        sut.productCodeTextPublishedSubject.onNext(five_Character_String)
        XCTAssertEqual(productCodeTextSpy.values, [five_Character_String])

        XCTAssertEqual(isUserInputValidSpy.values, [false, false, true])
    }
    
    func test_UserInput_Invalid_When_Less_Than_5_Characters_Long() throws {

        let sut = RootViewModel()
        let productCodeTextSpy = ValueSpy<String>(sut.productCodeTextPublishedSubject.asObservable())
        let isUserInputValidSpy = ValueSpy<Bool>(sut.isUserInputValid())

        XCTAssertEqual(isUserInputValidSpy.values, [false, false])
        
        let less_Than_Five_Character_String = "1234"
        sut.productCodeTextPublishedSubject.onNext(less_Than_Five_Character_String)
        XCTAssertEqual(productCodeTextSpy.values, [less_Than_Five_Character_String])

        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false])
    }
    
    func test_UserInput_Invalid_When_More_Than_5_Characters_Long() throws {

        let sut = RootViewModel()
        let productCodeTextSpy = ValueSpy<String>(sut.productCodeTextPublishedSubject.asObservable())
        let isUserInputValidSpy = ValueSpy<Bool>(sut.isUserInputValid())

        XCTAssertEqual(isUserInputValidSpy.values, [false, false])
        
        let more_Than_Five_Character_String = "123456"
        sut.productCodeTextPublishedSubject.onNext(more_Than_Five_Character_String)
        XCTAssertEqual(productCodeTextSpy.values, [more_Than_Five_Character_String])

        XCTAssertEqual(isUserInputValidSpy.values, [false, false, false])
    }
    

}

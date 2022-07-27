//
//  FetchUsernameServiceTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 27/07/2022.
//

import XCTest
@testable import ManyHands

class FetchUsernameServiceTests: XCTestCase {

    func test_fetchUsername_Sends_Result_If_Result_Is_Not_Nil() throws {
        
        let test_Username = "Test Username"
        let mockUserFetchingService = MockUserFetchingService()
        mockUserFetchingService.usernameResult = test_Username
        let sut = FetchUsernameService(usernameFetcher: mockUserFetchingService.mockFetchUsername)
        
        let observer = sut.fetchUsername(for: "test-id").asObservable()
        let spy = ValueSpy<String>(observer)
        
        XCTAssertEqual(spy.values, [test_Username])
        XCTAssertNil(spy.error)
    }
    
    func test_fetchUsername_Sends_Error_If_Result_Is_Nil() throws {
        
        let mockUserFetchingService = MockUserFetchingService()
        mockUserFetchingService.usernameResult = nil
        let sut = FetchUsernameService(usernameFetcher: mockUserFetchingService.mockFetchUsername)
        
        let observer = sut.fetchUsername(for: "test-id").asObservable()
        let spy = ValueSpy<String>(observer)
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
    }
    
    func test_fetchUsername_Sends_Error_If_UserId_Is_Nil() throws {
        
        let mockUserFetchingService = MockUserFetchingService()
        mockUserFetchingService.usernameResult = "Username"
        let sut = FetchUsernameService(usernameFetcher: mockUserFetchingService.mockFetchUsername)
        
        let nil_String : String? = nil
        let observer = sut.fetchUsername(for: nil_String).asObservable()
        let spy = ValueSpy<String>(observer)
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
    }
    
    func test_fetchUsername_Sends_Error_If_UserId_Is_Empty() throws {
        
        let mockUserFetchingService = MockUserFetchingService()
        mockUserFetchingService.usernameResult = "Username"
        let sut = FetchUsernameService(usernameFetcher: mockUserFetchingService.mockFetchUsername)
        
        let empty_String = ""
        let observer = sut.fetchUsername(for: empty_String).asObservable()
        let spy = ValueSpy<String>(observer)
        
        XCTAssertEqual(spy.values, [])
        XCTAssertNotNil(spy.error)
    }

}

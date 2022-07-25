//
//  MockUserFetchingService.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 25/07/2022.
//

import Foundation
import RxSwift

class MockUserFetchingService {
    
    var usernameResult:String? = "Username"

    func mockFetchUsername(for userId:String, observer:AnyObserver<String>, completion:@escaping(_ observer:AnyObserver<String>, _ username:String?)->Void) {
        completion(observer, usernameResult)
    }
}

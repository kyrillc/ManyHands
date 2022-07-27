//
//  MockUserService.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 20/07/2022.
//
import FirebaseAuth
import RxSwift

@testable import ManyHands


final class MockUserService : UserServiceProtocol {
    
    var signInResult:Result<Void, Error> = .success(())
    var registerResult:Result<Void, Error> = .success(())
    
    var usernameResult:String? = "Username"
    var authStateListenerCurrentUserResult:User? = nil
    var currentUserResult:MHUser? = nil
    var authStateListener:AuthStateDidChangeListenerHandle?


    func authStateListener(completion: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        completion(authStateListenerCurrentUserResult)
        return NSObject() as AuthStateDidChangeListenerHandle
    }
    
    func removeStateDidChangeListener(_ authStateListener: AuthStateDidChangeListenerHandle?) {
        //
    }
    
    func currentUser() -> MHUser? {
        return currentUserResult
    }
    
    
    func signIn(with username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(signInResult)
    }
    
    func signOut() throws {
        //
    }
    
    func register(with username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(registerResult)
    }
    
    func fetchUsername(for userId: String?) -> Observable<String> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create {}
            }
            if let usernameResult = self.usernameResult {
                observer.onNext(usernameResult)
            }
            else {
                observer.onError(NSError(domain: "", code: -1))
            }
            return Disposables.create {}
        }
    }

}

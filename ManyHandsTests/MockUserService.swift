//
//  MockUserService.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 20/07/2022.
//
import FirebaseAuth

@testable import ManyHands


final class MockUserService : UserServiceProtocol {
    
    var signInResult:Result<Void, Error> = .success(())
    var registerResult:Result<Void, Error> = .success(())
    
    var currentUserResult:User? = nil
    var authStateListener:AuthStateDidChangeListenerHandle?


    func authStateListener(completion: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        completion(currentUserResult)
        return authStateListener!
    }
    
    func removeStateDidChangeListener(_ authStateListener: AuthStateDidChangeListenerHandle?) {
        //
    }
    
    func currentUser() -> User? {
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

}

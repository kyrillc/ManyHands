//
//  UserService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 20/07/2022.
//

import Foundation
import FirebaseAuth

protocol UserServiceProtocol {
    func signIn(with username:String, password:String, completion: @escaping(Result<Void, Error>) -> Void)
    func signOut() throws
    func register(with username:String, password:String, completion: @escaping(Result<Void, Error>) -> Void)
}

final class UserService:UserServiceProtocol {
    
    func signIn(with username:String, password:String, completion: @escaping(Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: username, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            else {
                print("Signed In!")
                completion(.success(()))
            }
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let error {
            throw error
        }
    }
    
    func register(with username:String, password:String, completion: @escaping(Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: username, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            else {
                print("Registered!")
                completion(.success(()))
            }
        }
    }

}

//
//  UserService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 20/07/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import RxSwift

protocol UserServiceProtocol {
    func authStateListener(completion: @escaping(User?) -> Void) -> AuthStateDidChangeListenerHandle
    func removeStateDidChangeListener(_ authStateListener:AuthStateDidChangeListenerHandle?)
    func signIn(with username:String, password:String, completion: @escaping(Result<Void, Error>) -> Void)
    func signOut() throws
    func register(with username:String, password:String, completion: @escaping(Result<Void, Error>) -> Void)
    func currentUser() -> User?
    func fetchUsername(for userPath:String?) -> Observable<String>
}

final class UserService:UserServiceProtocol {
    
    func authStateListener(completion: @escaping(User?) -> Void) -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { auth, user in
            completion(user)
        }
    }
    
    func removeStateDidChangeListener(_ authStateListener:AuthStateDidChangeListenerHandle?){
        if let authStateListener = authStateListener {
            Auth.auth().removeStateDidChangeListener(authStateListener)
        }
    }
    
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
    
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func fetchUsername(for userPath:String?) -> Observable<String> {
        
        return Observable.create { observer -> Disposable in
            guard let userPath = userPath else {
                observer.onError(NSError.init(domain: "", code: -1))
                return Disposables.create {}
            }
            let db = Firestore.firestore()
            db.document(userPath).getDocument { document, error in
                if let error = error {
                    print("get user failed with error:\(error.localizedDescription)")
                }
                else {
                    print("get user succeedeed")
                    guard let document = document else {
                        observer.onError(NSError.init(domain: "", code: -1))
                        return
                    }
                    
                    if (document.exists) {
                        if let userData = document.data() {
                            print("userData:\(String(describing: userData))")
                            if let username = userData["name"] as? String {
                                print("username:\(username)")
                                observer.onNext(username)
                                return
                            }
                        }
                    }
                }
                observer.onError(NSError.init(domain: "", code: -1))
                
            }
            return Disposables.create {}
        }
    }
    

}

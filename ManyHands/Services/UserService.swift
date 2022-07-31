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
    func currentUser() -> MHUser?
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
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            else {
                guard let self = self else { return }
                if let user = user {
                    print("Signed In user:\(user.user.uid)")
                }

                self.userExistsOnFirestore { [weak self] exists in
                    guard let self = self else {
                        return
                        
                    }
                    if exists {
                        completion(.success(()))
                    }
                    if !exists {
                        print("User is not in database")
                        self.addUserToFirestore(user?.user, completion: { result in
                            switch result {
                            case .success(let userId):
                                print("Added user \(userId) to Firestore")
                                completion(.success(()))
                            case .failure(let error):
                                print("ERROR: Could not add user to Firestore")
                                completion(.failure(error))
                            }
                        })
                    }
                }
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
        Auth.auth().createUser(withEmail: username, password: password) { [weak self] user, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            else {
                print("Registered!")
                guard let self = self else { return }
                self.addUserToFirestore(user?.user, completion: { result in
                    switch result {
                    case .success(let userId):
                        print("Added user \(userId) to Firestore")
                        completion(.success(()))
                    case .failure(let error):
                        print("ERROR: Could not add user to Firestore")
                        completion(.failure(error))
                    }
                })
            }
        }
    }
    
    func currentUser() -> MHUser? {
        if let user = Auth.auth().currentUser {
            return MHUser(userId: user.uid, email: user.email ?? "")
        }
        return nil
    }
    
    private func userExistsOnFirestore(completion:@escaping(Bool) -> Void) {
        guard let user = currentUser() else { return }
        let userId = user.userId

        let db = Firestore.firestore()
        let docRef = db.collection(DatabaseCollections.users).document(userId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                completion(true)
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    
    private func addUserToFirestore(_ user:User?, completion: @escaping(Result<String, Error>) -> Void) {
        guard let user = user else { return }
        guard let userEmail = user.email else { return }
        let userData = ["name":userEmail] as [String : Any]
        let userId = user.uid

        let db = Firestore.firestore()
        db.collection(DatabaseCollections.users).document(userId).setData(userData, merge: true) { error in
            if let error = error {
                print("add user failed with error:\(error.localizedDescription)")
                completion(.failure(NSError(domain: "", code: -1)))
            }
            else {
                print("add user succeedeed")
                completion(.success(userId))
            }
        }
                
    }
}

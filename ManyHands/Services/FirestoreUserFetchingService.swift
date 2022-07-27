//
//  UserFetchingService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 24/07/2022.
//

import Foundation
import FirebaseFirestore
import RxSwift

class FirestoreUserFetchingService{
    
    class func fetchUsernameFromFirestore(for userId:String, observer:AnyObserver<String>, completion:@escaping(_ observer:AnyObserver<String>, _ username:String?)->Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection(DatabaseCollections.users).document(userId)
        docRef.getDocument { (document, error) in
            if let error = error {
                print("get user failed with error:\(error.localizedDescription)")
                observer.onError(error)
            }
            else {
                //print("get user succeedeed")
                guard let document = document else {
                    observer.onError(NSError.init(domain: "fetchUsername.document is nil", code: -1))
                    return
                }
                if document.exists == false {
                    observer.onError(NSError.init(domain: "fetchUsername.document.exists is false", code: -1))
                    return
                }
                guard let userData = document.data() else {
                    observer.onError(NSError.init(domain: "fetchUsername.document.data() is nil", code: -1))
                    return
                }
                completion(observer, userData["name"] as? String)
            }
        }
    }
}




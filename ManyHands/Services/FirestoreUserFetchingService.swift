//
//  UserFetchingService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 24/07/2022.
//

import Foundation
import FirebaseFirestore
import RxSwift

enum FirestoreUserFetchingServiceError: Error {
    case failedToGetDocumentSnapshot
    case failedToGetDocumentData
    case documentDoesNotExist
}
extension FirestoreUserFetchingServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToGetDocumentSnapshot:
            return NSLocalizedString(
                "Failed to get document snapshot.",
                comment: ""
            )
        case .failedToGetDocumentData:
            return NSLocalizedString(
                "Failed to get document data.",
                comment: ""
            )
        case .documentDoesNotExist:
            return NSLocalizedString(
                "Document does not exist.",
                comment: ""
            )
        }
    }
}

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
                    observer.onError(FirestoreUserFetchingServiceError.failedToGetDocumentSnapshot)
                    return
                }
                if document.exists == false {
                    observer.onError(FirestoreUserFetchingServiceError.documentDoesNotExist)
                    return
                }
                guard let userData = document.data() else {
                    observer.onError(FirestoreUserFetchingServiceError.failedToGetDocumentData)
                    return
                }
                completion(observer, userData["name"] as? String)
            }
        }
    }
}




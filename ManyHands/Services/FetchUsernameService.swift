//
//  FetchUsernameService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 24/07/2022.
//

import Foundation
import RxSwift

enum FetchUsernameServiceError: Error {
    case failedToGetUserId
    case failedToGetUserName
}
extension FetchUsernameServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToGetUserId:
            return NSLocalizedString(
                "Failed to get user id.",
                comment: ""
            )
        case .failedToGetUserName:
            return NSLocalizedString(
                "Failed to get user name.",
                comment: ""
            )
        }
    }
}

class FetchUsernameService {
    
    typealias UsernameFetcher = (String, AnyObserver<String>, @escaping(AnyObserver<String>, String?)->Void) -> Void
    
    private let usernameFetcher:UsernameFetcher
    
    init(usernameFetcher: @escaping UsernameFetcher = FirestoreUserFetchingService.fetchUsernameFromFirestore) {
        self.usernameFetcher = usernameFetcher
    }
        
    func fetchUsername(for userId:String?) -> Observable<String> {
        
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else {
                return Disposables.create {}
            }
            guard let userId = userId else {
                observer.onError(FetchUsernameServiceError.failedToGetUserId)
                return Disposables.create {}
            }
            if userId.isEmpty {
                observer.onError(FetchUsernameServiceError.failedToGetUserId)
                return Disposables.create {}
            }

            self.usernameFetcher(userId, observer) { observer, username in
                guard let username = username else {
                    observer.onError(FetchUsernameServiceError.failedToGetUserName)
                    return
                }
                observer.onNext(username)
            }
            return Disposables.create {}
        }
    }
}


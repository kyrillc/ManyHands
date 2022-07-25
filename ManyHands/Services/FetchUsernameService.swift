//
//  FetchUsernameService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 24/07/2022.
//

import Foundation
import RxSwift

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
                observer.onError(NSError.init(domain: "fetchUsername.userId is nil", code: -1))
                return Disposables.create {}
            }

            self.usernameFetcher(userId, observer) { observer, username in
                guard let username = username else {
                    observer.onError(NSError.init(domain: "fetchUsername.document.data().name is nil", code: -1))
                    return
                }
                print("username:\(username)")
                observer.onNext(username)
            }
            return Disposables.create {}
        }
    }
}


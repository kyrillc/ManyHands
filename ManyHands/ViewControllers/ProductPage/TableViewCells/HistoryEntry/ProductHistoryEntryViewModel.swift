//
//  ProductHistoryEntryViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 26/07/2022.
//

import Foundation
import RxSwift
import RxRelay

struct ProductHistoryEntryViewModel:Equatable {
    static func == (lhs: ProductHistoryEntryViewModel, rhs: ProductHistoryEntryViewModel) -> Bool {
        return (lhs.historyEntry == rhs.historyEntry
                && lhs.entryText == rhs.entryText
                && lhs.entryDateString == rhs.entryDateString)
    }
    
    
    private let historyEntry:MHHistoryEntry
    private let usernameService:FetchUsernameService
    private let userService:UserServiceProtocol

    private var disposeBag = DisposeBag()
    let entryAuthorPublishedSubject = BehaviorRelay<String>(value: "")

    // let entryImage:UIImage

    var entryText:String {
        get {
            return historyEntry.entryText ?? ""
        }
    }
    var entryDateString:String {
        get {
            return historyEntry.entryDate.formatted()
        }
    }
    
    /// Used to identify a ProductPageCellModel
    var identity: String {
        return "ProductHistoryEntryViewModel:" + entryText + "\(Int64(historyEntry.entryDate.timeIntervalSince1970 * 1000))"
    }
    
    init(historyEntry:MHHistoryEntry,
         getUsernameService:(() -> FetchUsernameService) = { FetchUsernameService() },
         userService:UserServiceProtocol = UserService()) {

        self.historyEntry = historyEntry
        self.usernameService = getUsernameService()
        self.userService = userService

        fetchEntryAuthor().subscribe { [self] value in
            self.entryAuthorPublishedSubject.accept(value)
        } onError: { [self] error in
            print("fetchEntryAuthor error:\(error.localizedDescription)")
            self.entryAuthorPublishedSubject.accept("")
        }.disposed(by: disposeBag)
    }
    
    func userIsAuthor() -> Bool {
        return (historyEntry.userId == userService.currentUser()?.userId)
    }
    
    func userCanEditEntry() -> Bool {
        return userIsAuthor()
    }
    
    func fetchEntryAuthor() -> Observable<String> {
        usernameService.fetchUsername(for: historyEntry.userId)
    }
}

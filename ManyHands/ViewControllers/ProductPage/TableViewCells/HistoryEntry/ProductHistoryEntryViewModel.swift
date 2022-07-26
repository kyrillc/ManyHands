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
    
    
    private let historyEntry:HistoryEntry
    private let usernameService:FetchUsernameService

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
    
    init(historyEntry:HistoryEntry, getUsernameService:(() -> FetchUsernameService) = { FetchUsernameService() }) {
        self.historyEntry = historyEntry
        self.usernameService = getUsernameService()
        
        fetchEntryAuthor().subscribe { [self] value in
            self.entryAuthorPublishedSubject.accept(value)
        } onError: { [self] error in
            print("fetchEntryAuthor error:\(error.localizedDescription)")
            self.entryAuthorPublishedSubject.accept("")
        }.disposed(by: disposeBag)
    }
    
    func fetchEntryAuthor() -> Observable<String> {
        usernameService.fetchUsername(for: historyEntry.userId)
    }
}

//
//  ProductViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift

struct ProductViewModel {
    
    private let product:Product
    
    var productDescriptionViewModel : ProductDescriptionViewModel
    var productHistoryEntriesViewModels: [ProductHistoryEntryViewModel]
    
    var title:String? {
        return product.name ?? product.humanReadableId
    }
    
    var descriptionString:String? {
        return product.productDescription ?? ""
    }

    // UserService for each ProductHistoryEntryViewModel should be different, which is why I pass a closure and not a reference to a UserService directly.
    init(product:Product, getUserService:(() -> UserServiceProtocol) = { UserService() }) {
        self.product = product
        
        productHistoryEntriesViewModels = [ProductHistoryEntryViewModel]()
        if let historyEntries = product.historyEntries {
            productHistoryEntriesViewModels = historyEntries.map({ entry in
                ProductHistoryEntryViewModel(historyEntry:entry, getUserService: getUserService)
            })
        }
        
        productDescriptionViewModel = ProductDescriptionViewModel(productDescription: product.productDescription ?? "",
                                                                  currentOwner: product.ownerUserId ?? "")
    }
    
}

struct ProductDescriptionViewModel:Equatable {
    // let image:UIImage
    let productDescription:String
    let currentOwner:String
}

struct ProductHistoryEntryViewModel:Equatable {
    static func == (lhs: ProductHistoryEntryViewModel, rhs: ProductHistoryEntryViewModel) -> Bool {
        return (lhs.historyEntry == rhs.historyEntry
                && lhs.entryText == rhs.entryText
                && lhs.entryDateString == rhs.entryDateString
                && lhs.entryAuthor == rhs.entryAuthor)
    }
    
    
    private let historyEntry:HistoryEntry
    private let userService:UserServiceProtocol

    private var disposeBag = DisposeBag()
    let entryAuthorPublishedSubject = PublishSubject<String>()

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
    var entryAuthor:String {
        get {
            return historyEntry.userPath ?? ""
        }
    }
    
    init(historyEntry:HistoryEntry, getUserService:(() -> UserServiceProtocol) = { UserService() }) {
        self.historyEntry = historyEntry
        self.userService = getUserService()
        
        fetchEntryAuthor().bind(to: entryAuthorPublishedSubject).disposed(by: disposeBag)
    }
    
    func fetchEntryAuthor() -> Observable<String> {
        userService.fetchUsername(for: historyEntry.userPath)
    }
}

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


    // FetchUsernameService for each ProductHistoryEntryViewModel should be different, which is why I pass a closure and not a reference to a FetchUsernameService directly.
    init(product:Product, getUsernameService:(() -> FetchUsernameService) = { FetchUsernameService() }) {
        self.product = product
        
        productHistoryEntriesViewModels = [ProductHistoryEntryViewModel]()
        if let historyEntries = product.historyEntries {
            productHistoryEntriesViewModels = historyEntries.map({ entry in
                ProductHistoryEntryViewModel(historyEntry:entry, getUsernameService: getUsernameService)
            })
        }
        
        productDescriptionViewModel = ProductDescriptionViewModel(productDescription: product.productDescription ?? "",
                                                                  ownerUserId:product.ownerUserId,
                                                                  getUsernameService: getUsernameService)
    }
    
    
    
}

struct ProductDescriptionViewModel:Equatable {
    static func == (lhs: ProductDescriptionViewModel, rhs: ProductDescriptionViewModel) -> Bool {
        lhs.productDescription == rhs.productDescription
    }
    
    // let image:UIImage
    let productDescription:String
    private let usernameService:FetchUsernameService
    private var disposeBag = DisposeBag()
    private var ownerUserId:String?
    let productOwnerPublishedSubject = PublishSubject<String>()

    init(productDescription:String, ownerUserId:String?, getUsernameService:(() -> FetchUsernameService) = { FetchUsernameService() }) {
        self.productDescription = productDescription
        self.ownerUserId = ownerUserId
        self.usernameService = getUsernameService()
        fetchProductOwner().bind(to: productOwnerPublishedSubject).disposed(by: disposeBag)
    }
    private func fetchProductOwner() -> Observable<String> {
        usernameService.fetchUsername(for: ownerUserId)
            .map { owner in
            "Owner: \(owner)"
        }
    }
}

struct ProductHistoryEntryViewModel:Equatable {
    static func == (lhs: ProductHistoryEntryViewModel, rhs: ProductHistoryEntryViewModel) -> Bool {
        return (lhs.historyEntry == rhs.historyEntry
                && lhs.entryText == rhs.entryText
                && lhs.entryDateString == rhs.entryDateString)
    }
    
    
    private let historyEntry:HistoryEntry
    private let usernameService:FetchUsernameService

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
    
    init(historyEntry:HistoryEntry, getUsernameService:(() -> FetchUsernameService) = { FetchUsernameService() }) {
        self.historyEntry = historyEntry
        self.usernameService = getUsernameService()
        
        fetchEntryAuthor().bind(to: entryAuthorPublishedSubject).disposed(by: disposeBag)
    }
    
    func fetchEntryAuthor() -> Observable<String> {
        usernameService.fetchUsername(for: historyEntry.userId)
    }
}

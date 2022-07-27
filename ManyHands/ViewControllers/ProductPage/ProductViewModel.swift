//
//  ProductViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift
import RxRelay

class ProductViewModel {
    
    enum TableViewSection {
        case Description
        case HistoryEntries
        case Actions
    }
    enum ProductAction {
        case AddNewEntry
        case SetNewOwner
    }
    
    private var product:Product
    private let productService:ProductServiceProtocol
    private let userService:UserServiceProtocol

    var productDescriptionViewModel : ProductDescriptionViewModel
    var productHistoryEntriesViewModels: [ProductHistoryEntryViewModel]
    
    private let productHistoryEntriesViewModelsRx = BehaviorRelay<[ProductHistoryEntryViewModel]>(value: [])
    var productHistoryEntriesViewModelsObservable: Observable<[ProductHistoryEntryViewModel]> {
        return productHistoryEntriesViewModelsRx.asObservable()
    }
    
    var title:String? {
        return product.name ?? product.humanReadableId
    }
    
    var descriptionString:String? {
        return product.productDescription ?? ""
    }
    
    private var getUsernameService:(() -> FetchUsernameService)

    // FetchUsernameService for each ProductHistoryEntryViewModel should be different, which is why I pass a closure and not a reference to a FetchUsernameService directly.
    init(product:Product,
         getUsernameService:@escaping (() -> FetchUsernameService) = { FetchUsernameService() },
         productService:ProductServiceProtocol = ProductService(),
         userService:UserServiceProtocol = UserService()) {
        
        self.product = product
        self.productService = productService
        self.userService = userService
        self.getUsernameService = getUsernameService
        
        productHistoryEntriesViewModels = [ProductHistoryEntryViewModel]()
        productDescriptionViewModel = ProductDescriptionViewModel(productDescription: product.productDescription ?? "",
                                                                  ownerUserId:product.ownerUserId,
                                                                  getUsernameService: getUsernameService)

        self.computeSubViewModels()
    }
    
    private func computeSubViewModels(){
        productHistoryEntriesViewModels = [ProductHistoryEntryViewModel]()

        if let historyEntries = product.historyEntries?.sorted(by: { $0.entryDate.compare($1.entryDate) == .orderedAscending }) {
            productHistoryEntriesViewModels = historyEntries.map({ entry in
                ProductHistoryEntryViewModel(historyEntry:entry, getUsernameService: getUsernameService)
            })
        }
        
        productDescriptionViewModel = ProductDescriptionViewModel(productDescription: product.productDescription ?? "",
                                                                  ownerUserId:product.ownerUserId,
                                                                  getUsernameService: getUsernameService)
        
        productHistoryEntriesViewModelsRx.accept(productHistoryEntriesViewModels)
    }
    
    func sections() -> [TableViewSection]{
        var sections = [TableViewSection.Description]
        if product.historyEntries?.count ?? 0 > 0 {
            sections.append(.HistoryEntries)
        }
        if product.ownerUserId == userService.currentUser()?.userId {
            sections.append(.Actions)
        }
        return sections
    }
    
    func heightForRow(in section:Int) -> CGFloat {
        if sections()[section] == .Description {
            return 150
        }
        else if sections()[section] == .HistoryEntries {
            return 100
        }
        return 40
    }
    
    func rowCount(in section:Int) -> Int {
        if sections()[section] == .Description {
            return 1
        }
        else if sections()[section] == .HistoryEntries {
            return product.historyEntries?.count ?? 0
        }
        return actionRows().count
    }
    
    func actionRows() -> [ProductAction] {
        return [.AddNewEntry, .SetNewOwner]
    }
    
    private func actionTitle(for action:ProductAction) -> String {
        switch action {
        case .AddNewEntry:
            return "Add a comment"
        case .SetNewOwner:
            return "Set a new owner"
        }
    }
    
    func actionTitleForAction(at index:Int) -> String {
        return actionTitle(for: actionRows()[index])
    }
    
    func addNewEntry(entryText:String, completion:@escaping(Error?)->Void){
        let historyEntry = HistoryEntry(userId: userService.currentUser()?.userId,
                                        entryText: entryText,
                                        imageUrl: nil,
                                        entryDate: Date())
        
        productService.addHistoryEntry(historyEntry: historyEntry, to: product, completion: { [weak self] error in
            guard let self = self else {return}
            self.product.historyEntries?.append(historyEntry)
            self.computeSubViewModels()
            completion(error)
        })
    }
}

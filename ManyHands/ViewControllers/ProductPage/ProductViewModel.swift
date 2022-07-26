//
//  ProductViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift
import RxRelay

struct ProductViewModel {
    
    enum TableViewSection {
        case Description
        case HistoryEntries
        case Actions
    }
    enum ProductAction {
        case AddNewEntry
        case SetNewOwner
    }
    
    private let product:Product
    private let productService:ProductServiceProtocol

    var productDescriptionViewModel : ProductDescriptionViewModel
    var productHistoryEntriesViewModels: [ProductHistoryEntryViewModel]
    
    var title:String? {
        return product.name ?? product.humanReadableId
    }
    
    var descriptionString:String? {
        return product.productDescription ?? ""
    }


    // FetchUsernameService for each ProductHistoryEntryViewModel should be different, which is why I pass a closure and not a reference to a FetchUsernameService directly.
    init(product:Product,
         getUsernameService:(() -> FetchUsernameService) = { FetchUsernameService() },
         productService:ProductServiceProtocol = ProductService()) {
        
        self.product = product
        self.productService = productService
        
        productHistoryEntriesViewModels = [ProductHistoryEntryViewModel]()

        if let historyEntries = product.historyEntries?.sorted(by: { $0.entryDate.compare($1.entryDate) == .orderedAscending }) {
            productHistoryEntriesViewModels = historyEntries.map({ entry in
                ProductHistoryEntryViewModel(historyEntry:entry, getUsernameService: getUsernameService)
            })
        }
        
        productDescriptionViewModel = ProductDescriptionViewModel(productDescription: product.productDescription ?? "",
                                                                  ownerUserId:product.ownerUserId,
                                                                  getUsernameService: getUsernameService)
    }
    
    
    func sections() -> [TableViewSection]{
        var sections = [TableViewSection.Description]
        if product.historyEntries?.count ?? 0 > 0 {
            sections.append(.HistoryEntries)
        }
        if product.ownerUserId == UserService().currentUser()?.uid {
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
        let historyEntry = HistoryEntry(userId: UserService().currentUser()?.uid, entryText: entryText, imageUrl: nil, entryDate: Date())
        productService.addHistoryEntry(historyEntry: historyEntry, to: product, completion: completion)
    }
}

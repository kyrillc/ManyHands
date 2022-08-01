//
//  ProductViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift
import RxRelay

enum ProductViewModelError: Error {
    case failedToGetHistoryEntryAtSpecifiedIndex
}
extension ProductViewModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToGetHistoryEntryAtSpecifiedIndex:
            return NSLocalizedString(
                "Failed to get HistoryEntry at specified index.",
                comment: ""
            )
        }
    }
}

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
    
    private var product:MHProduct
    private let productService:ProductService
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
    
    private var getUsernameService:(() -> FetchUsernameService)

    // FetchUsernameService for each ProductHistoryEntryViewModel should be different, which is why I pass a closure and not a reference to a FetchUsernameService directly.
    init(product:MHProduct,
         getUsernameService:@escaping (() -> FetchUsernameService) = { FetchUsernameService() },
         productService:ProductService = ProductService(),
         userService:UserServiceProtocol = UserService()) {
        
        self.product = product
        self.productService = productService
        self.userService = userService
        self.getUsernameService = getUsernameService
        
        productHistoryEntriesViewModels = [ProductHistoryEntryViewModel]()
        productDescriptionViewModel = ProductDescriptionViewModel(productId: product.documentId,
                                                                  productDescription: product.productDescription ?? "",
                                                                  ownerUserId:product.ownerUserId,
                                                                  getUsernameService: getUsernameService)

        self.computeSubViewModels()
    }
    
    private func computeSubViewModels(){
        productHistoryEntriesViewModels = [ProductHistoryEntryViewModel]()

        if let historyEntries = product.historyEntries {
            productHistoryEntriesViewModels = historyEntries.map({ entry in
                ProductHistoryEntryViewModel(historyEntry:entry,
                                             getUsernameService: getUsernameService,
                                             userService: self.userService)
            })
        }
        
        productDescriptionViewModel = ProductDescriptionViewModel(productId: product.documentId,
                                                                  productDescription: product.productDescription ?? "",
                                                                  ownerUserId:product.ownerUserId,
                                                                  getUsernameService: getUsernameService)
        
        productHistoryEntriesViewModelsRx.accept(productHistoryEntriesViewModels)
    }
    
    private func userIsOwner() -> Bool {
        return (product.ownerUserId == userService.currentUser()?.userId)
    }
    
    func sections() -> [TableViewSection]{
        var sections = [TableViewSection.Description]
        if product.historyEntries?.count ?? 0 > 0 {
            sections.append(.HistoryEntries)
        }
        if userIsOwner() {
            sections.append(.Actions)
        }
        return sections
    }
    
    func userCanEditRow(at indexPath:IndexPath) -> Bool {
        if sections()[indexPath.section] == .HistoryEntries {
            let historyEntryModel = productHistoryEntriesViewModels[indexPath.row]
            return historyEntryModel.userIsAuthor()
        }
        return false
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
        if sections().contains(.Actions){
            return [.AddNewEntry, .SetNewOwner]
        }
        return []
    }
    
    func actionTitle(for action:ProductAction) -> String {
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
        let historyEntry = MHHistoryEntry(userId: userService.currentUser()?.userId,
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
    
    func deleteHistoryEntry(at index:Int, completion:@escaping(Error?)->Void) {
        guard let historyEntry = self.product.historyEntries?[index] else {
            completion(ProductViewModelError.failedToGetHistoryEntryAtSpecifiedIndex)
            return
        }
        productService.deleteHistoryEntry(historyEntry, from: self.product) { error in
            if let error = error {
                completion(error)
            }
            else {
                self.product.historyEntries?.remove(at: index)
                self.computeSubViewModels()
                completion(nil)
            }
        }
    }

}

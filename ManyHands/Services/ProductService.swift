//
//  ProductService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 31/07/2022.
//

import Foundation
import RxSwift

enum ProductServiceError: Error {
    case failedToGetDocumentId
}
extension ProductServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedToGetDocumentId:
            return NSLocalizedString(
                "Failed to get document id.",
                comment: ""
            )
        }
    }
}

class ProductService {
    
    private let productDatabaseService:ProductDatabaseServiceProtocol
    
    init(productDatabaseService: ProductDatabaseServiceProtocol = FirestoreProductDatabaseService ()) {
        self.productDatabaseService = productDatabaseService
    }
    
    func fetchProduct(with humanReadableId:String, withHistoryEntries:Bool) -> Observable<Product>{
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create {} }
            
            // This needs to have a completionHandler that returns (_ product:Product?, _ error:Error?)
            self.productDatabaseService.fetchProduct(with: humanReadableId, withHistoryEntries:withHistoryEntries) { product, error in
                if let product = product {
                    observer.onNext(product)
                }
                else if let error = error {
                    print("get products failed with error:\(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            return Disposables.create {}
        }
    }
    
    func addHistoryEntry(historyEntry:HistoryEntry, to product:Product, completion:@escaping(Error?)->Void){
        guard let documentId = product.documentId else {
            completion(ProductServiceError.failedToGetDocumentId)
            return
        }
        self.productDatabaseService.addHistoryEntry(historyEntry: historyEntry, with: documentId) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func deleteHistoryEntry(_ historyEntry:HistoryEntry, from product:Product, completion:@escaping(Error?)->Void){
        guard let productDocumentId = product.documentId else {
            completion(ProductServiceError.failedToGetDocumentId)
            return
        }
        guard let historyEntryDocumentId = historyEntry.documentId else {
            completion(ProductServiceError.failedToGetDocumentId)
            return
        }
        self.productDatabaseService.deleteHistoryEntry(with: historyEntryDocumentId, fromProductWith: productDocumentId) { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            }
            else {
                completion(nil)
            }
        }
    }

}

//
//  ProductService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 31/07/2022.
//

import Foundation
import RxSwift

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
            completion(NSError(domain: "ProductService.addHistoryEntry.error: Product has no documentId", code: -1))
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

}

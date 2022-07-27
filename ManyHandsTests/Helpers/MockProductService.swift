//
//  MockProductService.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 22/07/2022.
//

import Foundation
import RxSwift

@testable import ManyHands


final class MockProductService : ProductServiceProtocol {
    
    var returnedProduct:Product?
    var returnedFetchProductError:NSError?
    
    func fetchProduct(with humanReadableId: String, withHistoryEntries: Bool) -> Observable<Product> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create {} }
            if let returnedError = self.returnedFetchProductError {
                observer.onError(returnedError)
            }
            else if let returnedProduct = self.returnedProduct {
                observer.onNext(returnedProduct)
            }
            return Disposables.create {}
        }
    }
    
    var returnedAddHistoryEntryError:NSError?

    func addHistoryEntry(historyEntry: HistoryEntry, to product: Product, completion: @escaping (Error?) -> Void) {
        completion(returnedAddHistoryEntryError)
    }
    
}

//
//  ProductService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ProductServiceProtocol {
    func fetchProduct(with humanReadableId:String) -> Observable<Product>
}

class ProductService: ProductServiceProtocol {
    
    func fetchProduct(with humanReadableId:String) -> Observable<Product> {
        
        return Observable.create { observer -> Disposable in
            let db = Firestore.firestore()
            db.collection(DatabaseCollections.products)
                .whereField("humanReadableId", isEqualTo: humanReadableId)
                .getDocuments { snapshot, error in
                    
                    if let error = error {
                        print("get products failed with error:\(error.localizedDescription)")
                        observer.onError(error)
                    }
                    else {
                        print("get products succeedeed")
                        guard let snapshot = snapshot else {
                            observer.onError(NSError.init(domain: "", code: -1))
                            return
                        }
                        guard let documentData = snapshot.documents.first else {
                            observer.onError(NSError.init(domain: "", code: -1))
                            return
                        }
                        if documentData.exists == false {
                            observer.onError(NSError.init(domain: "", code: -1))
                            return
                        }
                        do {
                            let product = try documentData.data(as: Product.self)
                            // A 'Product' value was successfully initialized from the DocumentSnapshot.
                            print("Product: \(product)")
                            observer.onNext(product)
                        }
                        catch {
                            observer.onError(error)
                        }
                    }
                }
            return Disposables.create {}
        }
    }
}

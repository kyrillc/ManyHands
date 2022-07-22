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
        
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create {} }
            self.firestoreFetchProduct(with: humanReadableId) { [weak self] snapshot, error in
                guard let self = self else { return }
                self.handleFetchProductResponse(observer:observer, snapshot: snapshot, error: error)
            }
            return Disposables.create {}
        }
    }
    
    private func firestoreFetchProduct(with humanReadableId:String, completionHandler:@escaping (_ snapshot:QuerySnapshot?, _ error:Error?) -> (Void)) {
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products)
            .whereField("humanReadableId", isEqualTo: humanReadableId)
            .getDocuments{ snapshot, error in
                completionHandler(snapshot, error)
            }
    }
    
    private func handleFetchProductResponse(observer: AnyObserver<Product>, snapshot:QuerySnapshot?, error:Error?){
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
}

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
    func fetchProductWithHistoryEntries(with humanReadableId:String) -> Observable<Product>
}

class ProductService: ProductServiceProtocol {
    
    func fetchProductWithHistoryEntries(with humanReadableId:String) -> Observable<Product>{
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create {} }
            self.firestoreFetchProduct(with: humanReadableId) { [weak self] snapshot, error in
                guard let self = self else { return }
                self.handleFetchProductDataResponse(observer:observer, snapshot: snapshot, error: error)
            }
            return Disposables.create {}
        }
    }
    
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
    
    
    private func handleFetchProductDataResponse(observer: AnyObserver<Product>, snapshot:QuerySnapshot?, error:Error?){
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
            guard let productDocumentData = snapshot.documents.first else {
                observer.onError(NSError.init(domain: "", code: -1))
                return
            }
            if productDocumentData.exists == false {
                observer.onError(NSError.init(domain: "", code: -1))
                return
            }
            self.firestoreFetchHistoryEntries(with: productDocumentData) { [weak self] _productDocumentData, snapshot, error in
                guard let self = self else { return }
                self.handleFetchHistoryEntriesResponse(observer:observer, productDocumentData:_productDocumentData, snapshot: snapshot, error: error)
            }
        }
    }
    
    
    private func firestoreFetchHistoryEntries(with productDocumentData:QueryDocumentSnapshot,
                                              completionHandler:@escaping (_ productDocumentData:QueryDocumentSnapshot, _ snapshot:QuerySnapshot?, _ error:Error?) -> (Void)) {
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products).document(productDocumentData.documentID)
            .collection(DatabaseCollections.historyEntries)
            .getDocuments{ snapshot, error in
                completionHandler(productDocumentData, snapshot, error)
            }
    }
    
    private func handleFetchHistoryEntriesResponse(observer: AnyObserver<Product>, productDocumentData:QueryDocumentSnapshot, snapshot:QuerySnapshot?, error:Error?){
        do {
            var product = try productDocumentData.data(as: Product.self)
            // A 'Product' value was successfully initialized from the DocumentSnapshot.
            var historyEntries = [HistoryEntry]()
            
            if let error = error {
                print("get HistoryEntries failed with error:\(error.localizedDescription)")
                //observer.onError(error)
            }
            else {
                print("get HistoryEntries succeedeed")
                guard let snapshot = snapshot else {
//                    observer.onError(NSError.init(domain: "", code: -1))
                    observer.onNext(product)
                    observer.onCompleted()
                    return
                }
                if snapshot.isEmpty {
                    print("No historyEntry found")
                    //observer.onError(NSError.init(domain: "", code: -1))
                }
                else {
                    for documentData in snapshot.documents {
                        print("\(documentData.documentID) -> \(documentData.data())")
                        let userId = documentData.data()["userId"] as! DocumentReference
                        do {
                            var historyEntry = try documentData.data(as: HistoryEntry.self)
                            historyEntry.userPath = userId.path
                            // A 'HistoryEntry' value was successfully initialized from the DocumentSnapshot.
                            print("HistoryEntry: \(historyEntry)")
                            historyEntries.append(historyEntry)
                        } catch {
                            print("CATCH: documentData.data(as: HistoryEntry.self)")
                        }
                    }
                }
            }
            
            
            product.historyEntries = historyEntries
            print("Product with historyEntries: \(product)")
            observer.onNext(product)
            observer.onCompleted()
        }
        catch {
            observer.onError(error)
        }
        
    }
}

//
//  FirestoreProductDatabaseService.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 31/07/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ProductDatabaseServiceProtocol {
    
    func fetchProduct(with humanReadableId:String, withHistoryEntries:Bool,
                                                   completionHandler:@escaping (_ product:Product?, _ error:Error?) -> (Void))
    
    func fetchHistoryEntries(with documentID:String,
                             completionHandler:@escaping (_ historyEntries:[HistoryEntry]?, _ error:Error?) -> (Void))
    
    func addHistoryEntry(historyEntry:HistoryEntry, with productDocumentId:String, completion:@escaping(Error?)->Void)

    func deleteHistoryEntry(with historyEntryDocumentId:String, fromProductWith productDocumentId:String, completion:@escaping(Error?)->Void)
    
}

class FirestoreProductDatabaseService:ProductDatabaseServiceProtocol {
    
    func fetchProduct(with humanReadableId:String, withHistoryEntries:Bool,
                      completionHandler:@escaping (_ product:Product?, _ error:Error?) -> (Void)) {
        
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products)
            .whereField("humanReadableId", isEqualTo: humanReadableId)
            .getDocuments{ [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("get products failed with error:\(error.localizedDescription)")
                    completionHandler(nil, error)
                    return
                }
                else {
                    print("get products succeedeed")
                    guard let snapshot = snapshot else {
                        completionHandler(nil, NSError.init(domain: "handleFetchProductResponse.snapshot is nil", code: -1))
                        return
                    }
                    guard let productDocumentData = snapshot.documents.first else {
                        completionHandler(nil, NSError.init(domain: "handleFetchProductResponse.productDocumentData is nil", code: -1))
                        return
                    }
                    if productDocumentData.exists == false {
                        completionHandler(nil, NSError.init(domain: "handleFetchProductResponse.productDocumentData.exists is false", code: -1))
                        return
                    }
                    do {
                        var product = try productDocumentData.data(as: Product.self)
                        // A 'Product' value was successfully initialized from the DocumentSnapshot.
                        print("Product: \(product)")
                        product.documentId = productDocumentData.documentID
                        if (withHistoryEntries){
                            self.fetchHistoryEntries(with: productDocumentData.documentID) { historyEntries, error in
                                if let historyEntries = historyEntries {
                                    product.historyEntries = historyEntries.sorted(by: { $0.entryDate.compare($1.entryDate) == .orderedAscending })
                                    completionHandler(product, nil)
                                } else if let error = error {
                                    completionHandler(product, error)
                                }
                            }
                        }
                        else {
                            completionHandler(product, nil)
                        }
                    }
                    catch {
                        completionHandler(nil, error)
                    }
                }
            }
    }
    
    func fetchHistoryEntries(with documentID:String,
                             completionHandler:@escaping (_ historyEntries:[HistoryEntry]?, _ error:Error?) -> (Void)) {
        
        let db = Firestore.firestore()
        db.collection(DatabaseCollections.products).document(documentID)
            .collection(DatabaseCollections.historyEntries)
            .getDocuments{ snapshot, error in
                if let error = error {
                    print("get HistoryEntries failed with error:\(error.localizedDescription)")
                    completionHandler(nil, error)
                    return
                }
                else {
                    print("get HistoryEntries succeedeed")
                    guard let snapshot = snapshot else {
                        completionHandler(nil, error)
                        return
                    }
                    if snapshot.isEmpty {
                        print("No historyEntry found")
                        completionHandler([], nil)
                    }
                    else {
                        var historyEntries = [HistoryEntry]()
                        for documentData in snapshot.documents {
                            do {
                                var historyEntry = try documentData.data(as: HistoryEntry.self)
                                historyEntry.documentId = documentData.documentID
                                // A 'HistoryEntry' value was successfully initialized from the DocumentSnapshot.
                                // print("HistoryEntry: \(historyEntry)")
                                historyEntries.append(historyEntry)
                            } catch {
                                print("CATCH: documentData.data(as: HistoryEntry.self)")
                            }
                        }
                        completionHandler(historyEntries, nil)
                    }
                }
            }
    }
    
    func addHistoryEntry(historyEntry:HistoryEntry, with productDocumentId:String, completion:@escaping(Error?)->Void){
        let db = Firestore.firestore()
        do {
            let _ = try db.collection(DatabaseCollections.products).document(productDocumentId)
                .collection(DatabaseCollections.historyEntries)
                .addDocument(from: historyEntry, completion: { error in
                    completion(error)
                })
        } catch let error {
            completion(error)
        }
    }
    
    func deleteHistoryEntry(with historyEntryDocumentId:String, fromProductWith productDocumentId:String, completion:@escaping(Error?)->Void){
        let db = Firestore.firestore()
        let _ = db.collection(DatabaseCollections.products).document(productDocumentId)
            .collection(DatabaseCollections.historyEntries)
            .document(historyEntryDocumentId).delete { error in
                if let error = error {
                    print("delete historyEntry failed with error:\(error.localizedDescription)")
                }
                else {
                    print("delete historyEntry succeedeed")
                }
                completion(error)
            }
    }
    
}

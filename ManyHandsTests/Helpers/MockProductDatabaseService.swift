//
//  MockProductDatabaseService.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 31/07/2022.
//

import Foundation

@testable import ManyHands

class MockProductDatabaseService:ProductDatabaseServiceProtocol {
    
    var returnedProduct:Product?
    var returnedFetchProductError:NSError?

    var returnedAddHistoryEntryError:NSError?
    
    var deleteAddHistoryEntryError:NSError?

    func fetchProduct(with humanReadableId:String, withHistoryEntries: Bool,
                      completionHandler:@escaping (_ product:Product?, _ error:Error?) -> (Void)) {

        completionHandler(returnedProduct, returnedFetchProductError)
    }
    func fetchHistoryEntries(with documentID:String,
                             completionHandler:@escaping (_ historyEntries:[HistoryEntry]?, _ error:Error?) -> (Void)) {

        let testHistoryEntries:[HistoryEntry]? = nil
        let testError:Error? = nil
        completionHandler(testHistoryEntries, testError)
    }
    func addHistoryEntry(historyEntry:HistoryEntry, with productDocumentId:String, completion:@escaping(Error?)->Void){
        completion(returnedAddHistoryEntryError)
    }
    
    func deleteHistoryEntry(with historyEntryDocumentId: String, fromProductWith productDocumentId: String, completion: @escaping (Error?) -> Void) {
        completion(deleteAddHistoryEntryError)
    }
    

}

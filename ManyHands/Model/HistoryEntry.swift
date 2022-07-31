//
//  HistoryEntry.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct HistoryEntry:Codable, Equatable {
    
    // We could also use a DocumentReference in Firestore for userId, but this would require HistoryEntry to depend on the Firestore framework.
    var documentId:String?
    var userId:String?
    var entryText:String?
    var imageUrl:String?
    var entryDate:Date
    
    enum CodingKeys: String, CodingKey {
        case userId
        case entryText
        case imageUrl = "image"
        case entryDate
    }
}

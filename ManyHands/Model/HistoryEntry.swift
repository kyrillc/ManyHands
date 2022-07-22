//
//  HistoryEntry.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct HistoryEntry:Codable, CustomStringConvertible {
    var description: String { "HistoryEntry(productId:\(productId), userId:\(userId), entryDate:\(entryDate.description), imageUrl:\(imageUrl ?? "nil"), text:\(text ?? "nil"))" }

    let productId:String
    let userId:String
    var text:String?
    var imageUrl:String?
    var entryDate:Date
    
    enum CodingKeys: String, CodingKey {
        case productId
        case userId
        case text
        case imageUrl = "image"
        case entryDate
    }
}

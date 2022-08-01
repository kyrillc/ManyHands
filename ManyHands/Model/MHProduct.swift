//
//  MHProduct.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct MHProduct:Codable {
    
    var documentId:String?
    let humanReadableId:String?
    let isPublic:Bool?
    var name:String?
    var productDescription:String?
    var imageUrl:String?
    var entryDate:Date
    var year:Int?
    var ownerUserId:String? // Could be unused if we refer to product.owners.where(owningFromDate < Date() && owningUntilDate == nil)
    
    var historyEntries : [MHHistoryEntry]?
    
    enum CodingKeys: String, CodingKey {
        case humanReadableId
        case isPublic
        case name
        case productDescription = "description"
        case imageUrl = "image"
        case entryDate
        case year
        case ownerUserId
        case historyEntries
    }
}

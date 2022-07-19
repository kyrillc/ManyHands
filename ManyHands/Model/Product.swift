//
//  Product.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct Product:Codable, CustomStringConvertible {
    var description: String { "Product(humanReadableId:\(humanReadableId ?? "nil"), name:\(name ?? "nil"))" }
    
    let humanReadableId:String?
    var name:String?
    var productDescription:String?
    var imageUrl:String?
    var entryDate:Date
    var year:Int?
    var ownerUserId:String? // Could be unused if we refer to product.owners.where(owningFromDate < Date() && owningUntilDate == nil)
    
    enum CodingKeys: String, CodingKey {
        case humanReadableId
        case name
        case productDescription = "description"
        case imageUrl = "image"
        case entryDate
        case year
        case ownerUserId
    }
}

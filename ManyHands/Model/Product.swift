//
//  Product.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct Product {
    let id:String
    let humanReadableId:String?
    var name:String?
    var description:String?
    var imageUrl:String?
    var entryDate:Date
    var year:Int?
    var ownerUserId:String? // Could be unused if we refer to product.owners.where(owningFromDate < Date() && owningUntilDate == nil)
}

//
//  HistoryEntry.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct HistoryEntry {
    let id:String
    let productId:String
    let userId:String
    var text:String?
    var imageUrl:String?
    var entryDate:Date
}

//
//  HistoryEntry.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct HistoryEntry:Codable, Equatable {
    
    var userPath:String?
    var entryText:String?
    var imageUrl:String?
    var entryDate:Date
    
    enum CodingKeys: String, CodingKey {
        case userPath
        case entryText
        case imageUrl = "image"
        case entryDate
    }
}

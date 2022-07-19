//
//  ProductViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct ProductViewModel {
    
    private let product:Product
    
    var title:String {
        return product.name ?? product.humanReadableId!
    }
    
    init(product:Product) {
        self.product = product
    }
}

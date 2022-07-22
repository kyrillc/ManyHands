//
//  ProductViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation

struct ProductViewModel {
    
    private let product:Product
    
    var title:String? {
        return product.name ?? product.humanReadableId
    }
    
    var descriptionString:String? {
        return product.productDescription ?? ""
    }
    
    init(product:Product) {
        self.product = product
    }
}

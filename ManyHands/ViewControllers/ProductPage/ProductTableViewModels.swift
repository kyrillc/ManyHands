//
//  ProductTableViewModels.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 29/07/2022.
//

import Foundation
import RxDataSources

enum ProductPageCellModel {
    case Description(ProductDescriptionViewModel)
    case HistoryEntries(ProductHistoryEntryViewModel)
    case Actions(String)
}

extension ProductPageCellModel: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case .HistoryEntries(let productHistoryEntryViewModel):
            return productHistoryEntryViewModel.identity
        case .Description(let productDescriptionViewModel):
            return productDescriptionViewModel.identity
        case .Actions(let actionTitle):
            return "Action:\(actionTitle)"
        }
    }
}

struct ProductPageSectionModel {
    
    var items: [Item]

    var identity: Int {
        if let firstItem = items.first {
            switch firstItem {
            case .HistoryEntries(_):
                return 1
            case .Description(_):
                return 0
            case .Actions(_):
                return 2
            }
        }
        return 3
    }
}

extension ProductPageSectionModel: AnimatableSectionModelType {
    typealias Identity = Int
    typealias Item = ProductPageCellModel

    init(original: ProductPageSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

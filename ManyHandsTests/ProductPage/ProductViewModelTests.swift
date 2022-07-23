//
//  ProductViewModelTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 22/07/2022.
//

import XCTest
@testable import ManyHands

class ProductViewModelTests: XCTestCase {

    
    func test_ViewModels_Initialisation() throws {
        let humanReadableProductId = "12345"
        let test_Product_Description = "Test Product Description"
        let test_Product_Name = "Test Product Name"

        let historyEntryA = HistoryEntry(userId: "ABCD",
                                         entryDate: Date().addingTimeInterval(-30.0*60.0))
        
        let historyEntryB = HistoryEntry(userId: "EFGH",
                                         entryDate: Date().addingTimeInterval(-10.0*60.0))
        
        let historyEntries : [HistoryEntry] = [historyEntryA, historyEntryB]
        
        let product = Product(humanReadableId: humanReadableProductId,
                              isPublic: true,
                              name:test_Product_Name, productDescription: test_Product_Description,
                              entryDate: Date().addingTimeInterval(-60.0*60.0),
                              historyEntries: historyEntries)
        
        let historyEntryViewModelA = ProductHistoryEntryViewModel(historyEntry:historyEntryA,
                                                                  getUserService:{MockUserService()})
        let historyEntryViewModelB = ProductHistoryEntryViewModel(historyEntry:historyEntryB,
                                                                  getUserService:{MockUserService()})
        let productDescriptionViewModel = ProductDescriptionViewModel(productDescription: product.productDescription ?? "",
                                                                      ownerUserId: product.ownerUserId ?? "",
                                                                      getUserService: {MockUserService()})

        let sut = ProductViewModel(product: product, getUserService: {MockUserService()})
                
        XCTAssertEqual(sut.productHistoryEntriesViewModels, [historyEntryViewModelA, historyEntryViewModelB])
        XCTAssertEqual(sut.productDescriptionViewModel, productDescriptionViewModel)
        
        XCTAssertEqual(sut.productDescriptionViewModel.productDescription, test_Product_Description)
        XCTAssertEqual(sut.title, test_Product_Name)
    }

    

}

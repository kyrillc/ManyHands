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
                                                                  getUsernameService:{FetchUsernameService(usernameFetcher: MockUserFetchingService().mockFetchUsername)})
        let historyEntryViewModelB = ProductHistoryEntryViewModel(historyEntry:historyEntryB,
                                                                  getUsernameService:{FetchUsernameService(usernameFetcher: MockUserFetchingService().mockFetchUsername)})
        let productDescriptionViewModel = ProductDescriptionViewModel(productDescription: product.productDescription ?? "",
                                                                      ownerUserId: product.ownerUserId ?? "",
                                                                      getUsernameService: {FetchUsernameService(usernameFetcher: MockUserFetchingService().mockFetchUsername)})

        let sut = ProductViewModel(product: product, getUsernameService: {FetchUsernameService(usernameFetcher: MockUserFetchingService().mockFetchUsername)})
                
        XCTAssertEqual(sut.productHistoryEntriesViewModels, [historyEntryViewModelA, historyEntryViewModelB])
        XCTAssertEqual(sut.productDescriptionViewModel, productDescriptionViewModel)
        
        XCTAssertEqual(sut.productDescriptionViewModel.productDescription, test_Product_Description)
        XCTAssertEqual(sut.title, test_Product_Name)
    }
    
    func test_addNewEntry() throws {

        let historyEntryA = HistoryEntry(userId: "ABCD",
                                         entryDate: Date().addingTimeInterval(-30.0*60.0))
        let historyEntries : [HistoryEntry] = [historyEntryA]
        let product = Product(documentId:"documentId",
                              humanReadableId: "humanReadableId",
                              isPublic: true,
                              name:"", productDescription: "",
                              entryDate: Date().addingTimeInterval(-60.0*60.0),
                              historyEntries: historyEntries)
        let mockUserService = MockUserService()
        mockUserService.currentUserResult = MHUser(userId: "id", email: "email")
        
        
        let sut = ProductViewModel(product: product,
                                   getUsernameService: {FetchUsernameService(usernameFetcher: MockUserFetchingService().mockFetchUsername)},
                                   productService: MockProductService(),
                                   userService: mockUserService)
        
        
        XCTAssertEqual(sut.productHistoryEntriesViewModels.count, 1)

        sut.addNewEntry(entryText: "test") { error in
            XCTAssertNil(error)
            XCTAssertEqual(sut.productHistoryEntriesViewModels.count, 2)
            XCTAssertEqual(sut.productHistoryEntriesViewModels.last?.entryText, "test")
        }
    }
}

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

        let historyEntryA = HistoryEntry(userId: "id",
                                         entryDate: Date().addingTimeInterval(-30.0*60.0))
        
        let historyEntryB = HistoryEntry(userId: "id",
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

        let historyEntryA = HistoryEntry(userId: "id", entryDate: Date())
        let historyEntries : [HistoryEntry] = [historyEntryA]
        let sut = self.makeSUT(userIsProductOwner: true, historyEntries: historyEntries)
        
        XCTAssertEqual(sut.productHistoryEntriesViewModels.count, 1)

        sut.addNewEntry(entryText: "test") { error in
            XCTAssertNil(error)
            XCTAssertEqual(sut.productHistoryEntriesViewModels.count, 2)
            XCTAssertEqual(sut.productHistoryEntriesViewModels.last?.entryText, "test")
        }
    }
    
    func test_Sections_Contain_Actions_When_User_Is_Owner() throws {
        
        let historyEntryA = HistoryEntry(userId: "id", entryDate: Date())
        let historyEntries : [HistoryEntry] = [historyEntryA]
        
        let sut = self.makeSUT(userIsProductOwner: true, historyEntries: historyEntries)
        
        XCTAssertEqual(sut.sections(), [.Description, .HistoryEntries, .Actions])
    }
    
    func test_Sections_Dont_Contain_Actions_When_User_Is_Not_Owner() throws {
        
        let historyEntryA = HistoryEntry(userId: "id", entryDate: Date())
        let historyEntries : [HistoryEntry] = [historyEntryA]
        
        let sut = self.makeSUT(userIsProductOwner: false, historyEntries: historyEntries)
        
        XCTAssertEqual(sut.sections(), [.Description, .HistoryEntries])
    }
    
    func test_Sections_Dont_Contain_HistoryEntries_When_Product_Has_No_HistoryEntry() throws {
        let sut_User_Is_Not_Owner = self.makeSUT(userIsProductOwner: false, historyEntries: [])
        XCTAssertEqual(sut_User_Is_Not_Owner.sections(), [.Description])

        let sut_User_Is_Owner = self.makeSUT(userIsProductOwner: true, historyEntries: [])
        XCTAssertEqual(sut_User_Is_Owner.sections(), [.Description, .Actions])
    }
    
    
    func makeSUT(userIsProductOwner:Bool, historyEntries : [HistoryEntry]) -> ProductViewModel {
        let test_User_Id = "test-user-id"
        let owner_User_Id = userIsProductOwner ? test_User_Id : "owner-user-id"

        let product = Product(documentId:"documentId",
                              humanReadableId: "humanReadableId",
                              isPublic: true,
                              name:"", productDescription: "",
                              entryDate: Date().addingTimeInterval(-60.0*60.0),
                              ownerUserId:owner_User_Id,
                              historyEntries: historyEntries)
        
        let mockUserService = MockUserService()
        mockUserService.currentUserResult = MHUser(userId: test_User_Id, email: "email")
        
        return ProductViewModel(product: product,
                                   getUsernameService: {FetchUsernameService(usernameFetcher: MockUserFetchingService().mockFetchUsername)},
                                   productService: MockProductService(),
                                   userService: mockUserService)
    }
    
}

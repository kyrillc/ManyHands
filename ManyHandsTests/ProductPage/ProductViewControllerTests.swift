//
//  ProductViewControllerTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 20/07/2022.
//

import XCTest
@testable import ManyHands

class ProductViewControllerTests: XCTestCase {

    func test_ViewController_Does_Not_Render_Title_When_Product_Is_Incomplete() throws {
        
        let product = MHProduct(humanReadableId: nil, isPublic: true, name:nil, entryDate: Date())
        let productViewModel = ProductViewModel(product:product, userService: MockUserService())
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()

        XCTAssertNil(sut.title)
    }
    
    func test_ViewController_Renders_Title_As_HumanReadableId_When_Product_Has_No_Name() throws {
        
        let product = MHProduct(humanReadableId: "expectedTitleFromHumanReadableId", isPublic: true, name:nil, entryDate: Date())
        let productViewModel = ProductViewModel(product:product, userService: MockUserService())
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title, "expectedTitleFromHumanReadableId")
    }
    
    func test_ViewController_Renders_Title_As_Product_Name_When_Product_Has_A_Name() throws {
        
        let product = MHProduct(humanReadableId: "humanReadableId", isPublic: true, name: "expectedTitleFromName", entryDate: Date())
        let productViewModel = ProductViewModel(product:product, userService: MockUserService())
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title, "expectedTitleFromName")
        XCTAssertNotEqual(sut.title, "humanReadableId")
    }
        
    func test_addNewEntry_Should_Add_New_Row_In_HistoryEntries_Section() throws {

        let historyEntryA = MHHistoryEntry(userId: "id", entryDate: Date())
        let historyEntries : [MHHistoryEntry] = [historyEntryA]
        let productViewModel = makeProductViewModel(historyEntries: historyEntries)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 1)
        
        productViewModel.addNewEntry(entryText: "Test") { error in
            XCTAssertNil(error)
            XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 2)
        }
    }
    
    func test_deleteEntry_Should_Delete_Row_In_HistoryEntries_Section() throws {

        let historyEntryA = MHHistoryEntry(documentId:"doc-id", userId: "id-1", entryText:"entry 1", entryDate: Date().addingTimeInterval(TimeInterval(60)))
        let historyEntryB = MHHistoryEntry(documentId:"doc-id", userId: "id-2", entryText:"entry 2", entryDate: Date().addingTimeInterval(TimeInterval(-60)))
        let historyEntries : [MHHistoryEntry] = [historyEntryA, historyEntryB]
        let productViewModel = makeProductViewModel(historyEntries: historyEntries)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 2)
        
        productViewModel.deleteHistoryEntry(at: 1) { error in
            XCTAssertNil(error)
            XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 1)
        }
    }
    
    func makeProductViewModel(historyEntries : [MHHistoryEntry]) -> ProductViewModel {
        let product = MHProduct(documentId:"documentId",
                              humanReadableId: "humanReadableId",
                              isPublic: true,
                              name:"", productDescription: "",
                              entryDate: Date(),
                              historyEntries: historyEntries)
        let mockUserService = MockUserService()
        mockUserService.currentUserResult = MHUser(userId: "id", email: "email")
        
        
        return ProductViewModel(product: product,
                                   getUsernameService: {FetchUsernameService(usernameFetcher: MockUserFetchingService().mockFetchUsername)},
                                   productService: ProductService(productDatabaseService: MockProductDatabaseService()),
                                   userService: mockUserService)
    }
}

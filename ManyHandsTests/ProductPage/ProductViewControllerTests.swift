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
        
        let product = Product(humanReadableId: nil, isPublic: true, name:nil, entryDate: Date())
        let productViewModel = ProductViewModel(product:product)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()

        XCTAssertNil(sut.title)
    }
    
    func test_ViewController_Renders_Title_As_HumanReadableId_When_Product_Has_No_Name() throws {
        
        let product = Product(humanReadableId: "expectedTitleFromHumanReadableId", isPublic: true, name:nil, entryDate: Date())
        let productViewModel = ProductViewModel(product:product)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title, "expectedTitleFromHumanReadableId")
    }
    
    func test_ViewController_Renders_Title_As_Product_Name_When_Product_Has_A_Name() throws {
        
        let product = Product(humanReadableId: "humanReadableId", isPublic: true, name: "expectedTitleFromName", entryDate: Date())
        let productViewModel = ProductViewModel(product:product)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title, "expectedTitleFromName")
        XCTAssertNotEqual(sut.title, "humanReadableId")
    }
        
    func test_addNewEntry_Should_Add_New_Row_In_HistoryEntries_Section() throws {

        let historyEntryA = HistoryEntry(userId: "id", entryDate: Date())
        let historyEntries : [HistoryEntry] = [historyEntryA]
        let productViewModel = makeProductViewModel(historyEntries: historyEntries)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 1)
        
        productViewModel.addNewEntry(entryText: "Test") { error in
            XCTAssertEqual(sut.tableView.numberOfRows(inSection: 1), 2)
        }
    }
    
    
    func makeProductViewModel(historyEntries : [HistoryEntry]) -> ProductViewModel {
        let product = Product(documentId:"documentId",
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

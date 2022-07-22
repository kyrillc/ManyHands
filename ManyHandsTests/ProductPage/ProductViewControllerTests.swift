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

        sut.viewDidLoad()

        XCTAssertNil(sut.title)
    }
    
    func test_ViewController_Renders_Title_As_HumanReadableId_When_Product_Has_No_Name() throws {
        
        let product = Product(humanReadableId: "expectedTitleFromHumanReadableId", isPublic: true, name:nil, entryDate: Date())
        let productViewModel = ProductViewModel(product:product)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.viewDidLoad()

        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title, "expectedTitleFromHumanReadableId")
    }
    
    func test_ViewController_Renders_Title_As_Product_Name_When_Product_Has_A_Name() throws {
        
        let product = Product(humanReadableId: "humanReadableId", isPublic: true, name: "expectedTitleFromName", entryDate: Date())
        let productViewModel = ProductViewModel(product:product)
        let sut = ProductViewController(productViewModel: productViewModel)

        sut.viewDidLoad()

        XCTAssertNotNil(sut.title)
        XCTAssertEqual(sut.title, "expectedTitleFromName")
        XCTAssertNotEqual(sut.title, "humanReadableId")
    }

}

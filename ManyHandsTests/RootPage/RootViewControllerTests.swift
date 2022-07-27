//
//  RootViewControllerTests.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 22/07/2022.
//

import XCTest
@testable import ManyHands

final class RootViewControllerCollaboratorMock: RootViewControllerCollaboratorProtocol {

    private(set) var didCall_displayNewProductViewController = 0
    func displayNewProductViewController(from vc: RootViewController) {
        didCall_displayNewProductViewController += 1
    }
    
    private(set) var didCall_showLoginViewControllerIfNecessary = 0
    func showLoginViewControllerIfNecessary(from vc: RootViewController, rootViewModel: RootViewModel) {
        didCall_showLoginViewControllerIfNecessary += 1
    }
    
    private(set) var didCall_displayProductViewController = 0
    func displayProductViewController(with productViewModel: ProductViewModel, from vc: RootViewController) {
        didCall_displayProductViewController += 1
    }    
    
}


class RootViewControllerTests: XCTestCase {

    
    func test_Show_LoginViewController_If_No_User() throws{
        let mockUserService = MockUserService()
        mockUserService.currentUserResult = nil
        
        let rootViewModel = RootViewModel(userService: mockUserService)
        let sut = RootViewController()
        sut.rootViewModel = rootViewModel
        let mockCollaborator  = RootViewControllerCollaboratorMock()
        sut.collaborator = mockCollaborator
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(mockCollaborator.didCall_showLoginViewControllerIfNecessary, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertEqual(mockCollaborator.didCall_showLoginViewControllerIfNecessary, 1)
    }
    
    func test_Show_ProductPage_If_Product_Fetched_Successfully() throws{
        let mockProductService = MockProductService()
        mockProductService.returnedProduct = Product(humanReadableId: "", isPublic: false, entryDate: Date())
        
        let rootViewModel = RootViewModel(productService: mockProductService)
        let sut = RootViewController()
        sut.rootViewModel = rootViewModel
        let mockCollaborator  = RootViewControllerCollaboratorMock()
        sut.collaborator = mockCollaborator
        
        XCTAssertEqual(mockCollaborator.didCall_displayProductViewController, 0)

        sut.checkProductAction()

        XCTAssertEqual(mockCollaborator.didCall_displayProductViewController, 1)
    }
    
    func test_Do_Not_Show_ProductPage_If_Product_Fetch_Failed() throws{
        let mockProductService = MockProductService()
        mockProductService.returnedProduct = nil
        mockProductService.returnedFetchProductError = nil

        let rootViewModel = RootViewModel(productService: mockProductService)
        let sut = RootViewController()
        sut.rootViewModel = rootViewModel
        let mockCollaborator  = RootViewControllerCollaboratorMock()
        sut.collaborator = mockCollaborator
        
        XCTAssertEqual(mockCollaborator.didCall_displayProductViewController, 0)

        sut.checkProductAction()

        XCTAssertEqual(mockCollaborator.didCall_displayProductViewController, 0)
    }
    
    
    func test_Do_Not_Show_ProductPage_If_Product_Fetch_Returns_Error() throws{
        let mockProductService = MockProductService()
        mockProductService.returnedProduct = Product(humanReadableId: "", isPublic: false, entryDate: Date())
        mockProductService.returnedFetchProductError = NSError(domain: "", code: -1)

        let rootViewModel = RootViewModel(productService: mockProductService)
        let sut = RootViewController()
        sut.rootViewModel = rootViewModel
        let mockCollaborator  = RootViewControllerCollaboratorMock()
        sut.collaborator = mockCollaborator
        
        XCTAssertEqual(mockCollaborator.didCall_displayProductViewController, 0)

        sut.checkProductAction()

        XCTAssertEqual(mockCollaborator.didCall_displayProductViewController, 0)
    }

}

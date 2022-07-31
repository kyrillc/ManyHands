//
//  RootViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

final class RootViewModel {
    
    let signOutButtonString = "Sign Out"
    let titleString = Constants.appTitle
    let subtitleString = Constants.appSubtitle
    let orLabelString = "- OR -"

    let productCodeTextFieldPlaceHolderString = "Product ID (ex: AZ123)"
    let productCodeEnterButtonString = "Check Product!"
    let addProductButtonString = "Add a new product"

    private let productService:ProductService
    private let userService:UserServiceProtocol
    private var authStateListener:AuthStateDidChangeListenerHandle?

    let productCodeTextPublishedSubject = PublishSubject<String>()
    
    init(productService:ProductService = ProductService(), userService:UserServiceProtocol = UserService()) {
        self.productService = productService
        self.userService = userService
    }
    
    // MARK: - Fetch Product

    func fetchProductViewModel(with productId:String) -> Observable<ProductViewModel> {
        productService.fetchProduct(with: productId, withHistoryEntries: true).map {
            ProductViewModel(product: $0)
        }
    }
    
    // MARK: - User Input

    private func clearUserInput(){
        productCodeTextPublishedSubject.onNext("")
    }
    
    func isUserInputValid() -> Observable<Bool> {
        return productCodeTextPublishedSubject.asObservable()
            .startWith("")
            .map { productCode in
                return (productCode.count == 5)
            }.startWith(false)
    }
    
    // MARK: - User session state

    func setAuthStateListener(completion: @escaping(User?) -> Void) {
        authStateListener = userService.authStateListener(completion: completion)
    }
    
    func removeAuthStateListener() {
        userService.removeStateDidChangeListener(authStateListener)
    }
    
    func currentUser() -> MHUser? {
        return userService.currentUser()
    }
    
    func isLoggedIn() -> Bool {
        return (currentUser() != nil)
    }
    
    func signOut() throws {
        do {
            try userService.signOut()
            clearUserInput()
        } catch let error {
            print("signOut.error:\(error.localizedDescription)")
        }
    }

}

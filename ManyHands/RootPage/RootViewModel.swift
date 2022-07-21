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

    private let productService:ProductServiceProtocol
    private let userService:UserServiceProtocol
    private var authStateListener:AuthStateDidChangeListenerHandle?

    let productCodeTextPublishedSubject = PublishSubject<String>()
    
    init(productService:ProductServiceProtocol = ProductService(), userService:UserServiceProtocol = UserService()) {
        self.productService = productService
        self.userService = userService
    }
    
    func fetchProductViewModel(with productId:String) -> Observable<ProductViewModel> {
        productService.fetchProduct(with: productId).map {
            ProductViewModel(product: $0)
        }
    }
    
    func signOut() throws {
        do {
            try userService.signOut()
            clearUserInput()
        } catch let error {
            print("signOut.error:\(error.localizedDescription)")
        }
    }
    
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
    
    func setAuthStateListener(completion: @escaping(User?) -> Void) {
        authStateListener = userService.authStateListener(completion: completion)
    }
    
    func removeAuthStateListener() {
        userService.removeStateDidChangeListener(authStateListener)
    }
    
    func currentUser() -> User? {
        return userService.currentUser()
    }
    
    func isLoggedIn() -> Bool {
        return (currentUser() != nil)
    }

}

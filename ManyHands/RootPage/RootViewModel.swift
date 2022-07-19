//
//  RootViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import RxSwift
import RxCocoa

struct RootViewModel {
    
    let signOutButtonString = "Sign Out"
    let titleString = Constants.appTitle
    let subtitleString = Constants.appSubtitle
    let orLabelString = "- OR -"

    let productCodeTextFieldPlaceHolderString = "Product ID (ex: AZ123)"
    let productCodeEnterButtonString = "Check Product!"
    let addProductButtonString = "Add a new product"

    
    let productCodeTextPublishedSubject = PublishSubject<String>()
    
    func isUserInputValid() -> Observable<Bool> {
        return productCodeTextPublishedSubject.asObservable().startWith("").map { productCode in
            return (productCode.count == 5)
        }.startWith(false)
    }

}

//
//  ProductDescriptionViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 26/07/2022.
//

import Foundation
import RxSwift
import RxRelay

struct ProductDescriptionViewModel:Equatable {
    static func == (lhs: ProductDescriptionViewModel, rhs: ProductDescriptionViewModel) -> Bool {
        lhs.productDescription == rhs.productDescription
    }
    
    // let image:UIImage
    let productDescription:String
    private let usernameService:FetchUsernameService
    private var disposeBag = DisposeBag()
    private var ownerUserId:String?
    private var productId:String?
    
    let productOwnerPublishedSubject = BehaviorRelay<String>(value: "")
    
    /// Used to identify a ProductPageCellModel
    var identity: String {
        return "ProductDescriptionViewModel:\(productId ?? "")"
    }
    
    init(productId:String?,
         productDescription:String,
         ownerUserId:String?,
         getUsernameService:(() -> FetchUsernameService) = { FetchUsernameService() }) {
        
        self.productId = productId
        self.productDescription = productDescription
        self.ownerUserId = ownerUserId
        self.usernameService = getUsernameService()
        fetchProductOwner().subscribe { [self] value in
            self.productOwnerPublishedSubject.accept(value)
        } onError: { [self] error in
            print("fetchProductOwner error:\(error.localizedDescription)")
            self.productOwnerPublishedSubject.accept("")
        }.disposed(by: disposeBag)

    }
    private func fetchProductOwner() -> Observable<String> {
        usernameService.fetchUsername(for: ownerUserId)
            .map { owner in
            "Owner: \(owner)"
        }
    }
}

//
//  NewProductViewModel.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 01/09/2022.
//

import Foundation
import RxSwift

struct NewProductViewModel {
    
    struct NewProductFormSection {
        var cellModels = [NewProductCellModel]()
        var headerText:String? = nil
        var footerText:String? = nil
    }
    
    enum NewProductCellModel {
        case TextFieldCell(TextFieldCellViewModel)
        case TextViewCell(TextViewCellViewModel)
        case SwitchCell(SwitchCellViewModel)
    }
    
    let title = "New Product"
    let confirmButtonTitle = "Add"
    let formFooterText = "Making the product public makes it accessible to anyone. Making it private makes it accessible to the owners only."
    let formHeaderText = ""
    
    var productTitle = BehaviorSubject<String>(value: "")
    var productDescription = BehaviorSubject<String>(value: "")
    var isProductPublic = BehaviorSubject<Bool>(value: false)
    
    var productNameViewModel = TextFieldCellViewModel(title: "Product Name:", textFieldText: "", textFieldPlaceholder: "ex: Red dress")
    var productDescriptionViewModel = TextViewCellViewModel(title: "Product Description:", textViewText: "", textViewPlaceholder: "ex: This dress was made by my mother for my birthday!")
    var productIsPublicViewModel = SwitchCellViewModel(title: "Make this product public", subtitle: "", toggled: false)
    
    var formSections = [NewProductFormSection]()

    init() {
        formSections = [
            NewProductFormSection(cellModels:[NewProductCellModel.TextFieldCell(productNameViewModel),
                                    NewProductCellModel.TextViewCell(productDescriptionViewModel),
                                    NewProductCellModel.SwitchCell(productIsPublicViewModel)], headerText:formHeaderText, footerText:formFooterText)]
        
    }
    
    func isUserInputValid() -> Observable<Bool> {
        return productTitle.asObservable()
            .startWith("")
            .map { text in
                return (text.isEmpty == false)
            }.startWith(false)
    }
    
}

extension NewProductViewModel.NewProductCellModel {
    typealias Identity = String
    
    var height: CGFloat {
        switch self {
        case .TextFieldCell(let textFieldCellViewModel):
            return textFieldCellViewModel.height
        case .TextViewCell(let textViewCellViewModel):
            return textViewCellViewModel.height
        case .SwitchCell(let switchCellViewModel):
            return switchCellViewModel.height
        }
    }
}

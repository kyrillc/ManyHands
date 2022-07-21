//
//  UIViewControllerExtensions.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorAlert(with message:String){
        showAlert(with: "Error", message: message)
    }
    
    func showAlert(with title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        showDetailViewController(alert, sender: self)
    }
}

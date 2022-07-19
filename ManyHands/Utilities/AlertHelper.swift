//
//  AlertHelper.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import Foundation
import UIKit

class AlertHelper {
    
    static func showErrorAlert(with message:String, on viewController:UIViewController){
        AlertHelper.showAlert(with: "Error", message: message, on: viewController)
    }
    
    static func showAlert(with title:String, message:String, on viewController:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
}

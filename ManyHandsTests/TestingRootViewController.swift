//
//  TestingRootViewController.swift
//  ManyHandsTests
//
//  Created by Kyrill Cousson on 31/07/2022.
//

import UIKit

class TestingRootViewController:UIViewController {
    
    override func loadView() {
        let label = UILabel()
        label.text = "Running unit tests..."
        label.textAlignment = .center
        label.textColor = .white
        
        view = label
    }
}

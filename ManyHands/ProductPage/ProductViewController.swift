//
//  ProductViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import UIKit
import SnapKit

class ProductViewController: UIViewController {
    
    private var productViewModel:ProductViewModel!
    
    init(productViewModel:ProductViewModel) {
        self.productViewModel = productViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = productViewModel.title
        self.view.backgroundColor = .white
    }
}

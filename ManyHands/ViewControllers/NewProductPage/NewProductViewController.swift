//
//  NewProductViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 26/07/2022.
//

import UIKit
import SnapKit
import RxSwift

struct NewProductViewModel {
    let title = "New Product"
    let confirmButtonTitle = "Add Product"
    
    var productTitle = BehaviorSubject<String>(value: "")
    var productDescription = BehaviorSubject<String>(value: "")
    var isProductPublic = BehaviorSubject<Bool>(value: false)
}

class NewProductViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(), style: .insetGrouped)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    var newProductViewModel = NewProductViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = newProductViewModel.title
        self.view.backgroundColor = .systemBackground
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: newProductViewModel.confirmButtonTitle,
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(addProduct))
        
        addViews()
        setInitialUIProperties()
        setConstraints()
        setupTableView()
        setRxSwiftBindings()
    }
    
    
    // MARK: Initial Set-up

    private func addViews(){
        self.view.addSubview(tableView)
    }
    
    private func setupTableView(){
        tableView.reloadData()
    }
    
    private func setInitialUIProperties(){
        self.view.backgroundColor = .systemGroupedBackground
    }
    
    private func setConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.bottom.leading.trailing.equalTo(self.view)
        }
    }
    
    private func setRxSwiftBindings(){
        
    }
    
    // MARK: - Actions
    
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
    @objc func addProduct(){
        self.dismiss(animated: true)
    }
}

extension NewProductViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}


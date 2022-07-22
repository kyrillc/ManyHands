//
//  ProductViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import UIKit
import SnapKit

class ProductViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
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
        self.view.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView))
        
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
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    private func setInitialUIProperties(){
    }
    
    private func setConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.view)
        }
    }
    
    private func setRxSwiftBindings(){
        
    }
    
    // MARK: - Actions
    
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
}

extension ProductViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ProductDescriptionCell(cellViewModel: productViewModel, style: .default, reuseIdentifier: "ProductDescriptionCellIdentifier")
    }
    
    
}

class ProductDescriptionCell : UITableViewCell {
    
    private var cellViewModel:ProductViewModel!
    
    init(cellViewModel:ProductViewModel, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.cellViewModel = cellViewModel
        self.textLabel?.text = cellViewModel.descriptionString
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


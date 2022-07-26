//
//  ProductViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import UIKit
import SnapKit
import RxSwift

class ProductViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(), style: .insetGrouped)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ProductDescriptionCell.self, forCellReuseIdentifier: ProductDescriptionCell.identifier)
        tableView.register(HistoryEntryCell.self, forCellReuseIdentifier: HistoryEntryCell.identifier)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
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
        tableView.reloadData()
    }
    
    private func setInitialUIProperties(){
        self.view.backgroundColor = .systemGroupedBackground
    }
    
    private func setConstraints(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
        return productViewModel.sections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.rowCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (productViewModel.sections()[indexPath.section] == .Description) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductDescriptionCell.identifier, for: indexPath) as? ProductDescriptionCell else {
                return UITableViewCell()
            }
            cell.configureCell(cellViewModel: productViewModel.productDescriptionViewModel)
            return cell
        }
        else if (productViewModel.sections()[indexPath.section] == .HistoryEntries) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryEntryCell.identifier, for: indexPath) as? HistoryEntryCell else {
                return UITableViewCell()
            }
            cell.configureCell(cellViewModel: productViewModel.productHistoryEntriesViewModels[indexPath.row])
            return cell
        }
        else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ActionCell")
            cell.textLabel?.text = "Add an entry"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return productViewModel.heightForRow(in: indexPath.section)
    }
    
}

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
        return productViewModel.productHistoryEntriesViewModels.count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            return productViewModel.productHistoryEntriesViewModels.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 1) {
            return HistoryEntryCell(cellViewModel: productViewModel.productHistoryEntriesViewModels[indexPath.row],
                                    style: .subtitle,
                                    reuseIdentifier: "HistoryEntryCellIdentifier")
        }
        return ProductDescriptionCell(cellViewModel: productViewModel.productDescriptionViewModel,
                                      style: .subtitle,
                                      reuseIdentifier: "ProductDescriptionCellIdentifier")
    }
    
    
}

class ProductDescriptionCell : UITableViewCell {
    
    private var cellViewModel:ProductDescriptionViewModel!
    private var disposeBag = DisposeBag()

    init(cellViewModel:ProductDescriptionViewModel, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.cellViewModel = cellViewModel
        self.textLabel?.text = cellViewModel.productDescription
        if let detailTextLabel = detailTextLabel {
            self.cellViewModel.productOwnerPublishedSubject
                .bind(to: detailTextLabel.rx.text).disposed(by: disposeBag)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HistoryEntryCell : UITableViewCell {
    
    private var cellViewModel:ProductHistoryEntryViewModel!
    private var disposeBag = DisposeBag()

    init(cellViewModel:ProductHistoryEntryViewModel, style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.cellViewModel = cellViewModel
        self.textLabel?.text = cellViewModel.entryText
        if let detailTextLabel = detailTextLabel {
            self.cellViewModel.entryAuthorPublishedSubject.map({ author in
                "\(author) - \(cellViewModel.entryDateString)"
            }).bind(to: detailTextLabel.rx.text).disposed(by: disposeBag)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

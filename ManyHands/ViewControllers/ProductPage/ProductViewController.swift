//
//  ProductViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import UIKit
import SnapKit
import RxSwift

// MARK: Collaborator

protocol ProductViewControllerCollaboratorProtocol {
    func displayNewEntryViewController(with productViewModel:ProductViewModel, from vc:ProductViewController)
}

class ProductViewControllerCollaborator:ProductViewControllerCollaboratorProtocol {
    
    func displayNewEntryViewController(with productViewModel:ProductViewModel, from vc:ProductViewController){
        let newEntryViewController = NewEntryViewController(productViewModel: productViewModel)
        vc.showNavigationControllerEmbeddedDetailViewController(newEntryViewController)
    }
    
}

class ProductViewController: UIViewController {
    
    // MARK: - Views declaration

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(), style: .insetGrouped)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ProductDescriptionCell.self, forCellReuseIdentifier: ProductDescriptionCell.identifier)
        tableView.register(HistoryEntryCell.self, forCellReuseIdentifier: HistoryEntryCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Other properties

    private var productViewModel:ProductViewModel!
    private var collaborator:ProductViewControllerCollaboratorProtocol!
    private let disposeBag = DisposeBag()

    // MARK: - Init

    init(productViewModel:ProductViewModel, collaborator:ProductViewControllerCollaboratorProtocol = ProductViewControllerCollaborator()) {
        self.productViewModel = productViewModel
        self.collaborator = collaborator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Lifecycle

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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.bottom.leading.trailing.equalTo(self.view)
        }
    }
    
    private func setRxSwiftBindings(){
        productViewModel.productHistoryEntriesViewModelsObservable.subscribe { value in
            self.tableView.reloadData()
        } onError: { error in
            print(error.localizedDescription)
        } onCompleted: {
            print("productViewModel.productHistoryEntriesViewModelsRx.completed")
        } onDisposed: {
            print("productViewModel.productHistoryEntriesViewModelsRx.disposed")
        }.disposed(by: disposeBag)

    }
    
    // MARK: - Actions
    
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
}

// MARK: - TableView

extension ProductViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productViewModel.sections().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.rowCount(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch productViewModel.sections()[indexPath.section] {
        case .Description:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductDescriptionCell.identifier, for: indexPath) as? ProductDescriptionCell else {
                return UITableViewCell()
            }
            cell.configureCell(cellViewModel: productViewModel.productDescriptionViewModel)
            return cell
        case .HistoryEntries:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryEntryCell.identifier, for: indexPath) as? HistoryEntryCell else {
                return UITableViewCell()
            }
            cell.configureCell(cellViewModel: productViewModel.productHistoryEntriesViewModels[indexPath.row])
            return cell
        case .Actions:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ActionCell")
            cell.textLabel?.text = productViewModel.actionTitleForAction(at: indexPath.row)
            cell.selectionStyle = .default
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .link
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return productViewModel.heightForRow(in: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch productViewModel.sections()[indexPath.section] {
        case .Actions:
            switch productViewModel.actionRows()[indexPath.row] {
            case .AddNewEntry:
                print("AddNewEntry")
                collaborator.displayNewEntryViewController(with: productViewModel, from: self)
            case .SetNewOwner:
                print("SetNewOwner")
            }
        default:
            print("default")
        }
    }
    
}

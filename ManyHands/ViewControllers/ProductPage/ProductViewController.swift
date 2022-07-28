//
//  ProductViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 19/07/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

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
    }
    
    // MARK: Initial Set-up

    private func addViews(){
        self.view.addSubview(tableView)
    }
    
    private func setupTableView(){
        let descriptionCellModel = [ProductViewModel.CellModel.Description(productViewModel.productDescriptionViewModel)]
        let descriptionSectionModel = SectionModel(model: "Description Items", items: descriptionCellModel)

        let actionCellModels = productViewModel.actionRows().map { ProductViewModel.CellModel.Actions(productViewModel.actionTitle(for: $0)) }

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ProductViewModel.CellModel>>(configureCell: {
            dataSource, table, indexPath, item in
            switch item {
            case .Description(let productDescriptionViewModel):
                return self.makeProductDescriptionCell(productDescriptionViewModel: productDescriptionViewModel, forRowAt: indexPath) ?? UITableViewCell()
            case .HistoryEntries(let productHistoryEntryViewModel):
                return self.makeHistoryEntryCell(productHistoryEntryViewModel: productHistoryEntryViewModel, forRowAt: indexPath) ?? UITableViewCell()
            case .Actions(let actionTitle):
                return self.makeActionCell(cellTitle: actionTitle, forRowAt: indexPath)
            }
        })
        
        // Only productHistoryEntries section can change, so we observe its changes and bind to tableView datasource:
        productViewModel.productHistoryEntriesViewModelsObservable.map { [descriptionSectionModel, actionCellModels] productHistoryEntriesViewModels in
            
            // Compute all sections:
            
            var sectionArray = [descriptionSectionModel]

            let productHistoryCellModels = productHistoryEntriesViewModels.map { ProductViewModel.CellModel.HistoryEntries($0) }
            if productHistoryCellModels.count > 0 {
                let productHistorySectionModel = SectionModel(model: "HistoryEntry Items", items: productHistoryCellModels)
                sectionArray.append(productHistorySectionModel)
            }
            if actionCellModels.count > 0 {
                let actionSectionModel = SectionModel(model: "Action Items", items: actionCellModels)
                sectionArray.append(actionSectionModel)
            }
            return sectionArray
        }.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)

        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func makeProductDescriptionCell(productDescriptionViewModel:ProductDescriptionViewModel, forRowAt indexPath: IndexPath) -> ProductDescriptionCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductDescriptionCell.identifier, for: indexPath) as? ProductDescriptionCell
        cell?.configureCell(cellViewModel: productDescriptionViewModel)
        return cell
    }
    private func makeHistoryEntryCell(productHistoryEntryViewModel:ProductHistoryEntryViewModel, forRowAt indexPath: IndexPath) -> HistoryEntryCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryEntryCell.identifier, for: indexPath) as? HistoryEntryCell
        cell?.configureCell(cellViewModel: productViewModel.productHistoryEntriesViewModels[indexPath.row])
        return cell
    }
    private func makeActionCell(cellTitle:String, forRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ActionCell")
        cell.textLabel?.text = productViewModel.actionTitleForAction(at: indexPath.row)
        cell.selectionStyle = .default
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .link
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return cell
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
    
    // MARK: - Actions
    
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
}

// MARK: - TableView Delegate

extension ProductViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return productViewModel.heightForRow(in: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch productViewModel.sections()[indexPath.section] {
        case .Actions:
            switch productViewModel.actionRows()[indexPath.row] {
            case .AddNewEntry:
                collaborator.displayNewEntryViewController(with: productViewModel, from: self)
            case .SetNewOwner:
                print("SetNewOwner")
            }
        default:
            print("default")
        }
    }
}

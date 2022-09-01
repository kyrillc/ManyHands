//
//  NewProductViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 26/07/2022.
//

import UIKit
import SnapKit
import RxSwift


class NewProductViewController: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.init(), style: .insetGrouped)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: TextFieldCell.identifier)
        tableView.register(TextViewCell.self, forCellReuseIdentifier: TextViewCell.identifier)
        tableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.identifier)
        return tableView
    }()
    
    var newProductViewModel = NewProductViewModel()
    private var disposeBag = DisposeBag()

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
        // Enable confirm button only when input is valid:
        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
            newProductViewModel.isUserInputValid().bind(to: rightBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
        }
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
        return newProductViewModel.formSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newProductViewModel.formSections[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = newProductViewModel.formSections[indexPath.section].cellModels[indexPath.row]
        switch cellViewModel {
        case .TextFieldCell(let textFieldCellViewModel):
            let cell = makeTextFieldCell(cellViewModel: textFieldCellViewModel, forRowAt: indexPath)
            cell?.textField.rx.text.map { $0 ?? "" }.bind(to: newProductViewModel.productTitle).disposed(by: disposeBag)
            return cell!
        case .TextViewCell(let textViewCellViewModel):
            let cell = makeTextViewCell(cellViewModel: textViewCellViewModel, forRowAt: indexPath)
            return cell!
        case .SwitchCell(let switchCellViewModel):
            let cell = makeSwitchCell(cellViewModel: switchCellViewModel, forRowAt: indexPath)
            return cell!
        }
    }
    private func makeTextFieldCell(cellViewModel:TextFieldCellViewModel, forRowAt indexPath: IndexPath) -> TextFieldCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.identifier, for: indexPath) as? TextFieldCell
        cell?.configureCell(cellViewModel: cellViewModel)
        return cell
    }
    private func makeTextViewCell(cellViewModel:TextViewCellViewModel, forRowAt indexPath: IndexPath) -> TextViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.identifier, for: indexPath) as? TextViewCell
        cell?.configureCell(cellViewModel: cellViewModel)
        return cell
    }
    private func makeSwitchCell(cellViewModel:SwitchCellViewModel, forRowAt indexPath: IndexPath) -> SwitchCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as? SwitchCell
        cell?.configureCell(cellViewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = newProductViewModel.formSections[indexPath.section].cellModels[indexPath.row]
        return cellViewModel.height
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return newProductViewModel.formSections[section].headerText
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return newProductViewModel.formSections[section].footerText
    }
}


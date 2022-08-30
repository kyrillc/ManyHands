//
//  NewEntryViewController.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 26/07/2022.
//

import Foundation
import SnapKit
import RxSwift

struct NewEntryViewModel {
    let placeholderText = "What's on your mind?"
    let title = "New comment"
    let confirmButtonTitle = "Post"
}

class NewEntryViewController:UIViewController {
    
    lazy var entryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private var productViewModel:ProductViewModel!
    private var newEntryViewModel = NewEntryViewModel()
    private var disposeBag = DisposeBag()
    
    init(productViewModel:ProductViewModel) {
        self.productViewModel = productViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(dismissView))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: newEntryViewModel.confirmButtonTitle,
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(postComment))
        
        addViews()
        setInitialUIProperties()
        setConstraints()
        setRxSwiftBindings()
        
        placeholderLabel.text = newEntryViewModel.placeholderText
        title = newEntryViewModel.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        entryTextView.becomeFirstResponder()
    }
    
    // MARK: Initial Set-up

    private func addViews(){
        view.addSubview(entryTextView)
        view.addSubview(placeholderLabel)
    }
    
    private func setInitialUIProperties(){
        self.view.backgroundColor = .systemBackground
    }
    
    private func setConstraints(){
        entryTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.bottom.leading.trailing.equalTo(self.view)
        }
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(entryTextView.snp.top).offset(8)
            make.leading.equalTo(entryTextView.snp.leading).offset(5)
            make.trailing.equalTo(entryTextView.snp.trailing).offset(-5)
        }
    }
    
    private func setRxSwiftBindings(){
        // Show placeholder only when entryTextView is empty:
        entryTextView.rx.text.orEmpty.map({ !$0.isEmpty }).bind(to: placeholderLabel.rx.isHidden).disposed(by: disposeBag)

        // Enable confirm button only when entryTextView is not empty:
        if let rightBarButtonItem = self.navigationItem.rightBarButtonItem {
            entryTextView.rx.text.orEmpty.map({ !$0.isEmpty }).bind(to: rightBarButtonItem.rx.isEnabled).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Actions
    
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
    
    @objc func postComment(){
        productViewModel.addNewEntry(entryText: entryTextView.text) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(with: error.localizedDescription)
            }
            else {
                self.dismiss(animated: true)
            }
        }
    }
}

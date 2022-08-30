//
//  TextViewCell.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 30/08/2022.
//

import UIKit
import SnapKit
import RxSwift

struct TextViewCellViewModel {
    var title = ""
    var textViewText = ""
    var textViewPlaceholder = ""
}

class TextViewCell : UITableViewCell {
    
    static let identifier = "TextViewCellIdentifier"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .placeholderText
        label.numberOfLines = 0
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.overrideUserInterfaceStyle = .light
        return textView
    }()
    
    private var cellViewModel:TextViewCellViewModel!
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .default

        addSubviews()
        setConstraints()
        setRxSwiftBindings()
    }
    
    private func addSubviews(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
        contentView.addSubview(placeholderLabel)
    }
    
    private func setConstraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(11)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-11)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.top).offset(8)
            make.leading.equalTo(textView.snp.leading).offset(5)
            make.trailing.equalTo(textView.snp.trailing).offset(-5)
        }
    }
    
    private func setRxSwiftBindings(){
        // Show placeholder only when textView is empty:
        textView.rx.text.orEmpty.map({ !$0.isEmpty }).bind(to: placeholderLabel.rx.isHidden).disposed(by: disposeBag)
    }
    
    func configureCell(cellViewModel:TextViewCellViewModel){
        self.cellViewModel = cellViewModel
        
        titleLabel.text = cellViewModel.title
        textView.text = cellViewModel.textViewText
        placeholderLabel.text = cellViewModel.textViewPlaceholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  HistoryEntryCell.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 26/07/2022.
//

import UIKit
import SnapKit
import RxSwift

class HistoryEntryCell : UITableViewCell {
    
    static let identifier = "HistoryEntryCellIdentifier"
    
    lazy var entryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var entryDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var entryAuthorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var cellViewModel:ProductHistoryEntryViewModel!
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setConstraints()
    }
    
    private func addSubviews(){
        addSubview(entryTextView)
        addSubview(entryDateLabel)
        addSubview(entryAuthorLabel)
    }
    
    private func setConstraints(){
        
        entryDateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(15)
            make.height.equalTo(20)
        }
        
        entryAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(20)
        }
        
        entryTextView.snp.makeConstraints { make in
            make.top.equalTo(entryDateLabel).offset(15)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-5)
        }
        
    }
    
    func configureCell(cellViewModel:ProductHistoryEntryViewModel){
        self.cellViewModel = cellViewModel
        
        self.cellViewModel.entryAuthorPublishedSubject
            .bind(to: entryAuthorLabel.rx.text).disposed(by: disposeBag)

        entryTextView.text = cellViewModel.entryText
        entryDateLabel.text = cellViewModel.entryDateString
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

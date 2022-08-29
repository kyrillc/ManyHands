//
//  TextFieldCell.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 02/08/2022.
//

import UIKit
import SnapKit
import RxSwift

struct TextFieldCellViewModel {
    var title = ""
    var textFieldText = ""
    var textFieldPlaceholder = ""
}

class TextFieldCell : UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "TextFieldCellIdentifier"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.overrideUserInterfaceStyle = .light
        return textField
    }()
    
    private var cellViewModel:TextFieldCellViewModel!
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .default

        addSubviews()
        setConstraints()
        
        textField.delegate = self
    }
        
    private func addSubviews(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)
    }
    
    private func setConstraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    func configureCell(cellViewModel:TextFieldCellViewModel){
        self.cellViewModel = cellViewModel
        
        titleLabel.text = cellViewModel.title
        textField.text = cellViewModel.textFieldText
        textField.placeholder = cellViewModel.textFieldPlaceholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

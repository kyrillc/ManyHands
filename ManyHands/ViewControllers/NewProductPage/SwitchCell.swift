//
//  SwitchCell.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 30/08/2022.
//

import UIKit
import SnapKit
import RxSwift

struct SwitchCellViewModel {
    var title = ""
    var subtitle = ""
    var toggled = false
    var height:CGFloat = 50
}

class SwitchCell : UITableViewCell {
    
    static let identifier = "SwitchCellIdentifier"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    lazy var uiSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = false
        return uiSwitch
    }()
    
    private var cellViewModel:SwitchCellViewModel!
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none

        addSubviews()
        setConstraints()
    }
    
    private func addSubviews(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(uiSwitch)
    }
    
    private func setConstraints(){
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(uiSwitch.snp.leading).offset(8)
            make.height.equalTo(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(uiSwitch.snp.leading).offset(-8)
        }
        
        uiSwitch.snp.makeConstraints { make in
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    func configureCell(cellViewModel:SwitchCellViewModel){
        self.cellViewModel = cellViewModel
        
        titleLabel.text = cellViewModel.title
        subtitleLabel.text = cellViewModel.subtitle
        uiSwitch.isOn = cellViewModel.toggled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

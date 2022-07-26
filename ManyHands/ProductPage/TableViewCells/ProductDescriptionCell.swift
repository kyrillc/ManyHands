//
//  ProductDescriptionCell.swift
//  ManyHands
//
//  Created by Kyrill Cousson on 26/07/2022.
//

import UIKit
import SnapKit
import RxSwift

class ProductDescriptionCell : UITableViewCell {
    
    
    static let identifier = "ProductDescriptionCellIdentifier"
    
    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProductPlaceholderImage")
        return imageView
    }()
    
    lazy var productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var productOwnerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var cellViewModel:ProductDescriptionViewModel!
    private var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubviews()
        setConstraints()
    }
    
    private func addSubviews(){
        addSubview(productImageView)
        addSubview(productDescriptionTextView)
        addSubview(productOwnerLabel)
    }
    
    private func setConstraints(){
        productImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.leadingMargin.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.height.width.equalTo(100)
        }
        
        productDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(productImageView.snp.right).offset(5)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(self.productOwnerLabel.snp.top)
        }
        
        productOwnerLabel.snp.makeConstraints { make in
            make.right.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.left.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-5)
            make.height.equalTo(20)
        }
    }
    
    func configureCell(cellViewModel:ProductDescriptionViewModel){
        self.cellViewModel = cellViewModel
        
        self.productDescriptionTextView.text = cellViewModel.productDescription
        self.cellViewModel.productOwnerPublishedSubject
            .bind(to: productOwnerLabel.rx.text).disposed(by: disposeBag)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

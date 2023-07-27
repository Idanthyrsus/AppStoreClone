//
//  ReviewCell.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 09.07.2023.
//

import Foundation
import UIKit
import SnapKit

class ReviewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Name"
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Author"
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "Some long review is going to be here"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        layer.cornerRadius = 16
        clipsToBounds = true
        
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElements() {

        addSubviews([
        titleLabel,
        userNameLabel,
        reviewLabel
        ])
        
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(30)
            make.width.equalTo(160)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    func configure(with model: Entry) {
        userNameLabel.text = model.author.name.label
        titleLabel.text = model.title.label
        reviewLabel.text = model.content.label
        
    }
}

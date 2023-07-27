//
//  DetailViewHeader.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 09.07.2023.
//

import Foundation
import UIKit
import SnapKit

class DetailViewHeader: UICollectionReusableView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().offset(-6)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with sectionName: String) {
        label.text = sectionName
    }
}

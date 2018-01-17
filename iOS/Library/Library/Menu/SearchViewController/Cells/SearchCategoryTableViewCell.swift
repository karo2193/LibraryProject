//
//  SearchCategoryTableViewCell.swift
//  Library
//
//  Created by Kryg Tomasz on 17.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

protocol SearchCategoryTableViewCellDelegate: class {
    func showCategoriesViewController()
}

class SearchCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .tintDark
            titleLabel.text = R.string.localizable.category()
        }
    }
    @IBOutlet weak var categoriesButton: UIButton! {
        didSet {
            categoriesButton.backgroundColor = .tintDark
            categoriesButton.setTitleColor(.main, for: .normal)
            categoriesButton.setTitle("Wybierz kategorie...", for: .normal)
            categoriesButton.layer.cornerRadius = 5.0
            categoriesButton.addTarget(self, action: #selector(onCategoriesButtonClicked), for: .touchUpInside)
        }
    }
    
    weak var delegate: SearchCategoryTableViewCellDelegate?
    var searchPropertyType: SearchPropertyType = .category
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func onCategoriesButtonClicked() {
        delegate?.showCategoriesViewController()
    }
    
}

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
            categoriesButton.setTitle(R.string.localizable.chooseCategories() + "...", for: .normal)
            categoriesButton.layer.cornerRadius = 5.0
            categoriesButton.addTarget(self, action: #selector(onCategoriesButtonClicked), for: .touchUpInside)
        }
    }
    
    weak var delegate: SearchCategoryTableViewCellDelegate?
    var searchPropertyType: SearchPropertyType = .category
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoriesButton.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func onCategoriesButtonClicked() {
        delegate?.showCategoriesViewController()
        categoriesButton.isUserInteractionEnabled = false
    }
    
    func refreshButtonTitle() {
        let searchedCategoriesCount = SessionManager.shared.searchedBook.categories.count
        let categoriesCountLastDigit = searchedCategoriesCount % 10
        var suffixWord = ""
        if searchedCategoriesCount == 0 {
            self.categoriesButton.setTitle(R.string.localizable.chooseCategories() + "...", for: .normal)
            return
        } else if searchedCategoriesCount == 1 {
            suffixWord = R.string.localizable.oneCategorySuffix()
        } else if searchedCategoriesCount > 4 && searchedCategoriesCount < 22 {
            suffixWord = R.string.localizable.threeCategorySuffix()
        } else if categoriesCountLastDigit == 2 || categoriesCountLastDigit == 3 || categoriesCountLastDigit == 4 {
            suffixWord = R.string.localizable.twoCategorySuffix()
        } else {
            suffixWord = R.string.localizable.threeCategorySuffix()
        }
        self.categoriesButton.setTitle("\(R.string.localizable.choosed()) \(searchedCategoriesCount) \(suffixWord)", for: .normal)
    }
    
}

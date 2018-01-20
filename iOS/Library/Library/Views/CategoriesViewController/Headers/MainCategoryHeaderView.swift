//
//  MainCategoryHeaderView.swift
//  Library
//
//  Created by Kryg Tomasz on 18.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

protocol MainCategoryHeaderViewDelegate: class {
    func toggleSubcategories(usingHeader header: MainCategoryHeaderView)
}

class MainCategoryHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var container: UIView! {
        didSet {
            container.backgroundColor = .main
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onHeaderTap))
            container.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var checkImageView: UIImageView! {
        didSet {
            checkImageView.image = #imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysTemplate)
            checkImageView.tintColor = .tintDark
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .tintDark
        }
    }
    @IBOutlet weak var topSeparatorView: UIView! {
        didSet {
            topSeparatorView.backgroundColor = .tintDark
        }
    }
    @IBOutlet weak var bottomSeparatorView: UIView! {
        didSet {
            bottomSeparatorView.backgroundColor = .tintDark
        }
    }
    
    weak var delegate: MainCategoryHeaderViewDelegate?
    var section: Int = 0
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                checkImageView.image = #imageLiteral(resourceName: "checked").withRenderingMode(.alwaysTemplate)
            } else {
                checkImageView.image = #imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysTemplate)
            }
//            delegate?.toggleSubcategories(usingHeader: self)
        }
    }
    var mainCategory: MainCategory? {
        didSet {
            titleLabel.text = mainCategory?.category?.name
        }
    }
    
    @objc func onHeaderTap() {
        delegate?.toggleSubcategories(usingHeader: self)
    }

}

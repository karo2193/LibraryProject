//
//  CategoryHeaderView.swift
//  Library
//
//  Created by Kryg Tomasz on 18.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

class CategoryHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var container: UIView! {
        didSet {
            container.backgroundColor = .main
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
    
    var mainCategory: MainCategory? {
        didSet {
            titleLabel.text = mainCategory?.category?.name
        }
    }

}

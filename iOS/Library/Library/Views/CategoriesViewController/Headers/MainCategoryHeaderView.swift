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
    func expandSubcategories(usingHeader header: MainCategoryHeaderView)
}

class MainCategoryHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var container: UIView! {
        didSet {
            container.backgroundColor = BACKGROUND_COLOR
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onHeaderTap))
            container.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var checkImageView: UIImageView! {
        didSet {
            checkImageView.image = #imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysTemplate)
            checkImageView.tintColor = ELEMENTS_COLOR
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = ELEMENTS_COLOR
        }
    }
    @IBOutlet weak var expandButton: UIButton! {
        didSet {
            expandButton.setTitle("", for: .normal)
            expandButton.tintColor = ELEMENTS_COLOR
            expandButton.setImage(#imageLiteral(resourceName: "expand").scale(toWidth: 24, height: 24), for: .normal)
            expandButton.addTarget(self, action: #selector(onExpandButtonClicked), for: .touchUpInside)
        }
    }
    @IBOutlet weak var topSeparatorView: UIView! {
        didSet {
            topSeparatorView.backgroundColor = ELEMENTS_COLOR
        }
    }
    @IBOutlet weak var bottomSeparatorView: UIView! {
        didSet {
            bottomSeparatorView.backgroundColor = ELEMENTS_COLOR
        }
    }
    
    private let BACKGROUND_COLOR: UIColor = .main
    private let ELEMENTS_COLOR: UIColor = .tintDark
    
    weak var delegate: MainCategoryHeaderViewDelegate?
    var section: Int = 0
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                checkImageView.image = #imageLiteral(resourceName: "checked").withRenderingMode(.alwaysTemplate)
            } else {
                checkImageView.image = #imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysTemplate)
            }
        }
    }
    var isExpanded: Bool = false {
        didSet {
            if isExpanded {
                expandButton.setImage(#imageLiteral(resourceName: "collapse").scale(toWidth: 24, height: 24), for: .normal)
            } else {
                expandButton.setImage(#imageLiteral(resourceName: "expand").scale(toWidth: 24, height: 24), for: .normal)
            }
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
    
    @objc func onExpandButtonClicked() {
        delegate?.expandSubcategories(usingHeader: self)
    }

}

//
//  CategoryTableViewCell.swift
//  Library
//
//  Created by Kryg Tomasz on 17.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

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
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = .tintDark
        }
    }
    
    var category: Category? {
        didSet {
            titleLabel.text = category?.name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkImageView.image = #imageLiteral(resourceName: "checked").withRenderingMode(.alwaysTemplate)
            } else {
                checkImageView.image = #imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = .main
        self.titleLabel.textColor = .tintDark
        self.checkImageView.tintColor = .tintDark
        self.separatorView.backgroundColor = .tintDark
        if selected {
            checkImageView.image = #imageLiteral(resourceName: "checked").withRenderingMode(.alwaysTemplate)
        } else {
            checkImageView.image = #imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysTemplate)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            self.contentView.backgroundColor = .tintDark
            self.titleLabel.textColor = .main
            self.checkImageView.tintColor = .main
        } else {
            self.contentView.backgroundColor = .main
            self.titleLabel.textColor = .tintDark
            self.checkImageView.tintColor = .tintDark
        }
    }
    
}

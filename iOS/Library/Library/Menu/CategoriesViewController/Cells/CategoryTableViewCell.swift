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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

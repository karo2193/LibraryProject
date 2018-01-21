//
//  BookDetailTableViewCell.swift
//  Library
//
//  Created by Kryg Tomasz on 21.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

class BookDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .tintDark
            titleLabel.text = "–"
        }
    }
    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.textColor = .tintDark
            detailsLabel.text = "–"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

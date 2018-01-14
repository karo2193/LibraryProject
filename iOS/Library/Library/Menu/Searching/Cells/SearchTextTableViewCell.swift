//
//  SearchTextTableViewCell.swift
//  Library
//
//  Created by Kryg Tomasz on 13.01.2018.
//  Copyright © 2018 Kryg Tomek. All rights reserved.
//

import UIKit

class SearchTextTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .tintDark
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.textColor = .tintDark
            textField.placeholder = "Wpisz szukaną frazę..."
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

extension SearchTextTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

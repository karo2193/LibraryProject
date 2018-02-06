//
//  BookTableViewCell.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = .tintDark
        }
    }
    @IBOutlet weak var authorLabel: UILabel! {
        didSet {
            authorLabel.textColor = .tintDark
        }
    }
    @IBOutlet weak var yearLabel: UILabel! {
        didSet {
            yearLabel.textColor = .tintDark
        }
    }
    @IBOutlet weak var arrowImageView: UIImageView! {
        didSet {
            arrowImageView.image = #imageLiteral(resourceName: "forward").withRenderingMode(.alwaysTemplate)
            arrowImageView.tintColor = .tintDark
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    func fill(using book: Book?) {
        titleLabel.text = book?.bookTitle
        if let author = book?.bookAuthors {
            if author.isEmpty {
                authorLabel.text = "—"
            } else {
                authorLabel.text = book?.bookAuthors
            }
        } else {
            authorLabel.text = "—"
        }
        if let year = book?.bookYear {
            if year.isEmpty {
                yearLabel.text = "—"
            } else {
                yearLabel.text = book?.bookYear
            }
        } else {
            yearLabel.text = "—"
        }
        
    }
    
}

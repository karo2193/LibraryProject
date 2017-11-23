//
//  ListViewController.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class ListViewController: MainVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
        }
    }
    
    weak var delegate: MainPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func onButtonClicked() {
        delegate?.previousViewController(from: self)
    }

}

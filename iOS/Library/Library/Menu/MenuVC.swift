//
//  MenuVC.swift
//  Library
//
//  Created by Kryg Tomasz on 29.10.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class MenuVC: MainVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        setColor(to: .main)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoginScreen()
    }
    
    private func showLoginScreen() {
        let storyboard = R.storyboard.login()
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        loginVC.modalPresentationStyle = .overCurrentContext
        self.present(loginVC, animated: true, completion: nil)
    }

}

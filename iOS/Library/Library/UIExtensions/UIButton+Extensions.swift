//
//  UIButton+Extensions.swift
//  Library
//
//  Created by Kryg Tomasz on 23.11.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

extension UIButton {
    
    public func appTheme() {
        self.backgroundColor = .tintLight
        self.setTitleColor(.main, for: .normal)
        self.layer.cornerRadius = 4
    }
    
}

//
//  UISearchBar+Utils.swift
//  Forecast
//
//  Created by Anton Morozov on 18.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    // Just for now
    // need to more deeply separate this control by versions of iOS
    // in iOS 13 added searchTextField
    
    func setupWhite() {
        self.tintColor = .black
        self.barTintColor = .white
        self.searchBarStyle = .minimal
        self.setImage(UIImage(), for: .clear, state: .normal)
        self.setImage(UIImage(), for: .search, state: .normal)
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            textfield.leftView = nil
            textfield.rightView = nil
            textfield.textColor = .black
            textfield.borderStyle = .none
            textfield.layer.cornerRadius = 5;
            textfield.clipsToBounds = true;
            textfield.backgroundColor = .white
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = .white
                backgroundview.subviews.forEach({ $0.removeFromSuperview() })
            }
        }
    }
}

//
//  OptionsButton.swift
//  PlusUno
//
//  Created by Mario Solano on 11/6/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class OptionsButton: UIButton {
    
    var centerXConstraint: NSLayoutConstraint?
    
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font = UIFont(name: "JosefinSans", size: 35) ?? UIFont.systemFont(ofSize: 35.0)
        backgroundColor = Theme.tintColor
        clipsToBounds = false
        layer.cornerRadius = 7.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

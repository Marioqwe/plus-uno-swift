//
//  InfoLabel.swift
//  PlusUno
//
//  Created by Mario Solano on 11/6/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class InfoLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont(name: "JosefinSans", size: 28) ?? UIFont.systemFont(ofSize: 28)
        textColor = Theme.tintColor
        textAlignment = .center
        baselineAdjustment = .alignCenters
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

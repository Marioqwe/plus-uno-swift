//
//  IconCell.swift
//  PlusUno
//
//  Created by Mario Solano on 11/6/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    static let identifier = "IconCell"
    var iconType: IconType!
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.darkGray : Theme.tintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = Theme.tintColor
        return iv
    }()
    
    private func setUpImageView() {
        addSubview(imageView)
        imageView.pinCenter(to: self)
        imageView.constraintHeight(to: self, multiplier: 1, constant: 0)
        imageView.constraintWidth(to: self, multiplier: 1, constant: 0)
    }
    
}

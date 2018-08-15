//
//  LevelCell.swift
//  PlusUno
//
//  Created by Mario Solano on 11/6/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class LevelCell: UICollectionViewCell {
    
    static let identifier = "LevelCell"
    
    var level: Int? {
        didSet {
            guard let level = self.level else { return }
            tileView.value = level
        }
    }
    
    private lazy var tileView: TileView = {
        let tv = TileView(frame: self.bounds, value: nil)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(tileView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

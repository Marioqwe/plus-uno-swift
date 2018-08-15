//
//  InfoBar.swift
//  PlusUno
//
//  Created by Mario Solano on 10/23/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class InfoBar: UIView {

    var controller: GameViewController?

    lazy private var levelLabel: InfoLabel! = {
        let label = InfoLabel()
        label.text = localizedString("LEVEL") + ": 0"
        
        return label
    }()
    
    private func setUpLevelLabel() {
        addSubview(levelLabel)
        
        levelLabel.constraintHeight(to: self, multiplier: 1, constant: 0)
        levelLabel.constraintWidth(to: self, multiplier: 0.5, constant: 0)
        levelLabel.constraintTrailing(to: self, attribute: .trailing, multiplier: 1, constant: 0)
        levelLabel.constraintTop(to: self, attribute: .top, multiplier: 1, constant: 0)
        
        layoutIfNeeded()
    }
    
    lazy private var movesLabel: InfoLabel! = {
        let label = InfoLabel()
        label.text = localizedString("MOVES") + ": 0"

        return label
    }()
    
    private func setUpMovesLabel() {
        addSubview(movesLabel)
        
        movesLabel.constraintHeight(to: self, multiplier: 1, constant: 0)
        movesLabel.constraintWidth(to: self, multiplier: 0.5, constant: 0)
        movesLabel.constraintTop(to: self, attribute: .top, multiplier: 1, constant: 0)
        movesLabel.constraintLeading(to: self, attribute: .leading, multiplier: 1, constant: 0)
        
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setUpLevelLabel()
        setUpMovesLabel()
    }
    
    /// Sets the number of moves text.
    func setMoves(_ newMoves: Int) {
        movesLabel.text = localizedString("MOVES") + ": \(newMoves)"
    }
    
    /// Sets the level text.
    func setLevel(_ newLevel: Int) {
        levelLabel.text = localizedString("LEVEL") + ": \(newLevel)"
    }
    
}


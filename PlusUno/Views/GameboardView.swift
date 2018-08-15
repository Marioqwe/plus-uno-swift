//
//  GameboardView.swift
//  PlusUno
//
//  Created by Mario Solano on 10/22/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

/// MARK: - AnimationParameters
struct AnimationParameters {

    static let popStartScale: CGFloat = 0.1
    static let popMaxScale: CGFloat = 1.05
    static let popDelay: TimeInterval = 0.05
    static let expandTime: TimeInterval = 0.1
    static let contractTime: TimeInterval = 0.08
    
}

/// MARK: - GameboardViewDelegate
protocol GameboardViewDelegate: class {
    
    func didTouchTile(at indexPath: IndexPath)
    
}

/// MARK: - GameboardView
class GameboardView: UIView {
    
    /// MARK: - Properties
    
    var delegate: GameboardViewDelegate?
    
    /// We'll use this value to aniamte the gameboard view in and out of its superview.
    var centerXConstraint: NSLayoutConstraint!
    
    /// Indicates whether the tiles have been drawn for the first time.
    /// Note: this looks extremely ugly but I could not think of a better solution :(.
    var didDrawTiles: Bool = false
    
    /// Number of columns in this gameboard view.
    fileprivate var numCols: Int!
    
    /// Number of rows in this gameboard view.
    fileprivate var numRows: Int!
    
    /// Dictionary containing the background views for our tiles.
    private var bgViews: [IndexPath: UIView] = {
        return [IndexPath: UIView]()
    }()
    
    /// Dictionary containing our tile views.
    private var tiles: [IndexPath: TileView] = {
        return [IndexPath: TileView]()
    }()
    
    /// Width and height for each tile.
    private lazy var tileSideLength: CGFloat = {
        let availableSideLength = self.bounds.width - self.padding * (CGFloat(self.numCols + 1))
        return CGFloat(floorf(CFloat(availableSideLength))) / CGFloat(self.numCols)
    }()
    
    /// The padding for each tile.
    private lazy var padding: CGFloat = {
       return self.frame.width * 0.025
    }()
    
    /// MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// MARK: - Superclass Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            for (indexPath, tileView) in bgViews {
                if tileView.frame.contains(touchLocation) {
                    delegate?.didTouchTile(at: indexPath)
                    return
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpSubviews()
    }
    
    /// MARK: Public Methods
    
    /// Sets the alpha value of the indicated tile to either 0.5 (selected) or 1.0 (not-selected).
    ///
    /// - Parameters:
    ///  - indexPath: the index path of the tile to be selected.
    ///  - flag: indicates whether the tile is to be selected or not.
    func selectTile(at indexPath: IndexPath, _ flag: Bool) {
        let tileView = tiles[indexPath]
        tileView?.alpha = flag ? 0.5 : 1.0
    }
    
    /// Inserts a tile into the view with a new-game animation if the tiles have not been drawn for
    /// the first time; otherwise, a pop-type animation is used instead.
    ///
    /// - Parameters:
    ///  - indexPath: the index path indicating where the tile needs to be added.
    ///  - value: the value for the tile.
    func insertTile(at indexPath: IndexPath, withValue value: Int) {
        guard let bgView = bgViews[indexPath] else { return }
        let tileView = TileView(frame: bgView.bounds, value: value)
        bgView.addSubview(tileView)
        
        if didDrawTiles {
            let oldTileView = tiles[indexPath]!
            let diff = tileView.value! - oldTileView.value!
            addFloatingLabel(withValue: diff, andFrame: bgView.frame)
            popAnimation(forTile: tileView, withIndexPath: indexPath)
        } else {
            let position = (indexPath.row, indexPath.section)
            if position != (1, 1) {
                /// We pop all tiles but the one in the center.
                popAnimation(forTile: tileView, withIndexPath: indexPath)
            }
        }
        
        tiles[indexPath] = tileView
    }
    
    /// Removes a tile from the view.
    ///
    /// - Parameters:
    ///  - indexPath: the index path to the tile to be removed.
    func removeTile(from indexPath: IndexPath) {
        let tileView = tiles[indexPath]
        tileView?.removeFromSuperview()
    }
    
    /// Make all tiles but the center one explode.
    ///
    /// - Parameters:
    ///  - callback: executed when the last tile has been removed from the view.
    func removeAllTiles(withCompletionCallback callback: (() -> Void)?) {
        for (indexPath, _) in tiles {
            if (indexPath.row, indexPath.section) != (1, 1) {
                let tile = tiles[indexPath]
                if (indexPath.row, indexPath.section) != (2, 2) {
                    tile?.explode(duration: 2, completion: {
                        callback?()
                    })
                } else {
                    tile?.explode(duration: 2)
                }
            }
        }
    }
    
    /// Sets all tile values to the initial state: 0 at the center, 1 everywhere else.
    func resetAllTileValues() {
        for (indexPath, tile) in tiles {
            let (row, col) = (indexPath.row, indexPath.section)
            if (row, col) == (1, 1) {
                tile.value = 0
            } else {
                tile.value = 1
            }
        }
    }
    
    func addPulsatingAnimation(atIndexPath indexPath: IndexPath) {
        guard let tileView = tiles[indexPath] else { return }
        tileView.addPulsatingLayer()
    }
    
    func removePulsatingAnimation(atIndexPath indexPath: IndexPath) {
        guard let tileView = tiles[indexPath] else { return }
        tileView.removePulsatingLayer()
    }
    
    func setColor(_ color: UIColor, forTileAtIndexPath indexPath: IndexPath) {
        guard let tileView = tiles[indexPath] else { return }
        tileView.backgroundColor = color
    }
    
    /// MARK: - Helper Methods
    
    /// Animation to make tiles 'pop' when they appear in the gameboard.
    private func popAnimation(forTile tile: TileView, withIndexPath indexPath: IndexPath) {
        tile.layer.setAffineTransform(CGAffineTransform.init(
            scaleX: AnimationParameters.popStartScale,
            y: AnimationParameters.popStartScale
        ))
        
        // Add to board animation
        UIView.animate(
            withDuration: AnimationParameters.expandTime,
            delay: AnimationParameters.popDelay,
            animations: { () -> Void in
                // Make the tile pop
                tile.layer.setAffineTransform(CGAffineTransform(scaleX: AnimationParameters.popMaxScale, y: AnimationParameters.popMaxScale))
        }) { (finished: Bool) -> Void in
            // Shrink the tile after it pops.
            UIView.animate(
                withDuration: AnimationParameters.contractTime,
                animations: {  () -> Void in
                    tile.layer.setAffineTransform(CGAffineTransform.identity)
            })
        }
    }
    
    /// Calculates the animation delay time for a given index path so that the tiles are animated in
    /// the following order:
    ///                         <-(9) <-(8) <-(7)
    ///                         (4)-> (5)-> (6)->
    ///                         <-(3) <-(2) <-(1)
    ///
    private func animationDelay(forTileAt indexPath: IndexPath) -> TimeInterval {
        let baseDelay: TimeInterval = 0.5
        let (row, col) = (indexPath.row, indexPath.section)
        
        var delay: TimeInterval
        let startFromRight = (numRows - indexPath.row + 1) % 2 == 0 ? true : false
        
        if startFromRight {
            delay = baseDelay + TimeInterval((numCols - 1) - col) * 0.3 + TimeInterval((numRows - 1) - row) * TimeInterval(numRows) * 0.3
        } else {
            delay = baseDelay + TimeInterval(col) * 0.3 + TimeInterval((numRows - 1) - row) * TimeInterval((numRows)) * 0.3
        }
        
        return delay
    }
    
    /// Adds a background view at each tile position in the view. The tile views will be subviews
    /// of these background views.
    private func setUpSubviews() {
        var xPos = padding
        var yPos: CGFloat
        
        for j_col in 0..<numCols {
            yPos = padding
            for i_row in 0..<numRows {
                let bgFrame = CGRect.init(x: xPos, y: yPos, width: tileSideLength, height: tileSideLength)
                let bgView = UIView(frame: bgFrame)
                addSubview(bgView)
                
                let indexPath = IndexPath(row: i_row, section: j_col)
                bgViews[indexPath] = bgView
                yPos += padding + tileSideLength
            }
            xPos += padding + tileSideLength
        }
    }
    
    /// Adds a floating label that moves northeast and dissapears after a given time interval.
    ///
    /// - Parameters:
    ///  - value: The value for the label.
    ///  - frame: The frame for the label.
    private func addFloatingLabel(withValue value: Int, andFrame frame: CGRect) {
        let numberLabel = UILabel()
        numberLabel.frame = frame
        numberLabel.text = value > 0 ? "+\(value)" : "\(value)"
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont(name: "JosefinSans", size: 40)
        numberLabel.textColor = Theme.tintColor
        numberLabel.backgroundColor = UIColor.clear
        addSubview(numberLabel)
        
        UIView.animate(withDuration: 1.3, animations: {
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 30, y: -120)
            t = t.scaledBy(x: 0.1, y: 0.1)
            numberLabel.transform = t
            numberLabel.alpha = 0.0
        }) { _ in
            numberLabel.removeFromSuperview()
        }
    }

}

/// MARK: - Static Constructors
extension GameboardView {
    
    static func initWith(numRows: Int, numCols: Int) -> GameboardView {
        let gbView = GameboardView()
        gbView.numCols = numCols
        gbView.numRows = numRows
        
        return gbView
    }
    
}

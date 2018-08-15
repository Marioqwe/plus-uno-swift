//
//  GameModel.swift
//  PlusUno
//
//  Created by Mario Solano on 10/21/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import Foundation

class GameState {
    
    /// The gameboard's tiles values.
    fileprivate var gridValues = [1, 1, 1, 1, 0, 1, 1, 1, 1]
    
    /// The number of moves executed + un-done.
    fileprivate var numMoves: Int!
    
    /// The current level. Use this value to determine valid moves.
    fileprivate var level: Int!
    
    /// Stores executed moves - this does not include un-done moves.
    fileprivate var movesBuffer: [[[Int]]] = [[[Int]]]()
    
    init(numMoves: Int = 0, level: Int) {
        self.numMoves = numMoves
        self.level = level
    }
    
    func addToMovesBuffer(tilePosition: (Int, Int), tileValue: Int, otherTilePosition: (Int, Int), otherTileValue: Int)  {
        movesBuffer.append([
            [tilePosition.0, tilePosition.1, tileValue],
            [otherTilePosition.0, otherTilePosition.1, otherTileValue]
            ])
    }
    
    func buildPayload() -> [String: Any] {
        return [
            "gridValues": gridValues,
            "numMoves": numMoves,
            "level": level,
            "movesBuffer": movesBuffer
        ] as [String: Any]
    }
    
    func getCenterTile() -> Int {
        return gridValues[4]
    }
    
    static func build(fromPayload payload: [String: Any]) -> GameState? {
        guard let gridValues = payload["gridValues"] as? [Int],
            let level = payload["level"] as? Int,
            let movesBuffer = payload["movesBuffer"] as? [[[Int]]],
            let numMoves = payload["numMoves"] as? Int else { return nil }
        
        let state = GameState(numMoves: numMoves, level: level)
        state.movesBuffer = movesBuffer
        state.gridValues = gridValues
        
        return state
    }
    
}

/// MARK: - Gameboard
extension Gameboard where T == TileObject {
    
    /// Inserts tiles with values to the gameboard.
    ///
    /// - Parameters:
    ///  - positions: positions for the new tiles within the gameboard.
    ///  - values: the values for the new tiles.
    mutating func insertTiles(at positions: [(Int, Int)], withValues values: [Int]) {
        for ((x, y), val) in zip(positions, values) {
            self[x, y] = (TileObject.Tile(val), false)
        }
    }
    
    /// Removes tiles from the gameboard.
    ///
    /// - Parameters:
    ///  - positions: the positions of the tiles to be removed.
    mutating func removeTiles(from positions: [(Int, Int)]) {
        for (x, y) in positions {
            self[x, y] = (TileObject.Empty, false)
        }
    }
    
}

/// MARK: - GameModelDelegate
protocol GameModelDelegate: class {
    
    /// Notifies the delegate that a new game has begun for the given level.
    func gameModel(_ model: GameModel, didStartNewGameWithLevel level: Int)
    
    /// Notifies the delegate whether tiles at given positions have been selected.
    func gameModel(_ model: GameModel, didSelectTilesAt positions: [(Int, Int)], _ flag: Bool)
    
    /// Notifies the delegate that the attempted move was invalid.
    func gameModel(_ model: GameModel, didSendInvalidMoveMessage message: String)
    
    /// Notifies the delegate that the tiles with given positions & values have been inserted into the gameboard.
    func gameModel(_ model: GameModel, didInsertTilesAt positions: [(Int, Int)], withValues value: [Int])
    
    /// Notifies the delegate that a move was undone at the given positions, with given values.
    func gameModel(_ model: GameModel, didUndoMoveAt positions: [(Int, Int)], withValues values: [Int])
    
    /// Notifies the delegate that tiles with given positions have been removed from the gameboard.
    func gameModel(_ model: GameModel, didRemoveTilesAt positions: [(Int, Int)])
    
    /// Notifies the delegate that the number of moves has increased to a given value.
    func gameModel(_ model: GameModel, didUpdateNumberOfMovesTo value: Int)
    
    /// Notifies the delegate that the given level has been cleared in the given number of moves.
    func gameModel(_ model: GameModel, didCompleteLevel level: Int, withTotalMoves moves: Int)
    
    /// Notifies the delegate that the game has been reset.
    func gameModel(_ model: GameModel, didResetLevel level: Int)
}


/// MARK: - GameModel
class GameModel: NSObject {
    
    typealias TiledGameboard = Gameboard<TileObject>
    
    /// MARK: Properties
    
    var delegate: GameModelDelegate?
    fileprivate var gameboard: TiledGameboard!
    fileprivate var state: GameState!
    
    /// Returns true if the current level has been cleared, false otherwise.
    /// Note that we consider the current level cleared if all tiles have the same value.
    private var isLevelCleared: Bool {
        get {
            for (row, col) in gameboard.positions {
                if gameboard[row, col].0.getValue() != state.level {
                    return false
                }
            }
            
            return true
        }
    }
    
    /// MARK: Public Methods
    
    /// The rules for PlusUno are simple; you tap a tile and:
    ///
    ///  - If no other tile is currently selected, then mark the tapped tile as
    ///    selected and return.
    ///  - If another tile is currently selected, then increase the value of the already
    ///    selected tile by '1' and the value of the tapped tile by the value of the already
    ///    selected tile.
    ///
    /// These rules must be fulfilled in order for the move to be valid:
    ///
    ///  (1) No tile can have a value larger than the current level.
    ///  (2) No tile can be merged with itself.
    ///
    /// The level is completed once all tiles have the same value.
    ///
    /// - Parameters:
    ///  - position: the position of the tile that has been tapped.
    func didTouchTile(at position: (Int, Int)) {
        let selectedTiles = gameboard.selectedItems()
        
        /// At most one tile can be selected at any given time.
        guard selectedTiles.count < 2 else { return }

        if selectedTiles.isEmpty {
            /// If no tiles are currently selected then we have a valid move. Mark the tapped
            /// tile as aselected, notify the delegate, and return.
            gameboard.markItem(withPosition: position, asSelected: true)
            delegate?.gameModel(self, didSelectTilesAt: [position], true)
            return
        }
            
        else {
            if position == selectedTiles[0] {
                /// Cannot combine a tile with itself.
                /// Notify the delegate and return.
                gameboard.markItem(withPosition: position, asSelected: false)
                delegate?.gameModel(self, didSelectTilesAt: [position], false)
                delegate?.gameModel(self, didSendInvalidMoveMessage: localizedString("SELF_MERGE_MESSAGE"))
                return
            }
            
            /// Already-selected tile increases by '1'.
            let tile_0_value = gameboard.getItem(at: selectedTiles[0]).getValue()
            let tile_0_newValue = tile_0_value + 1
            
            /// Touched tile increases by the value of the already-selected tile.
            let tile_1_value = gameboard.getItem(at: position).getValue()
            let tile_1_newValue = tile_1_value + tile_0_value
            
            if tile_0_newValue > state.level || tile_1_newValue > state.level {
                /// Tile values cannot be greater than the current level.
                /// Notify the delegate and return.
                gameboard.markItem(withPosition: position, asSelected: false)
                gameboard.markItem(withPosition: selectedTiles[0], asSelected: false)
                delegate?.gameModel(self, didSelectTilesAt: [selectedTiles[0], position], false)
                delegate?.gameModel(self, didSendInvalidMoveMessage: localizedString("OVER_LEVEL_MESSAGE"))
                return
            }
            
            /// If we reach this point then we have performed a valid move.
            
            /// Start by saving the current move. We'll come back to this whenever the user wants to undo a move.
            state.addToMovesBuffer(tilePosition: selectedTiles[0], tileValue: tile_0_value, otherTilePosition: position, otherTileValue: tile_1_value)
            
            /// Replace the old tiles.
            gameboard.removeTiles(from: [position, selectedTiles[0]])
            delegate?.gameModel(self, didRemoveTilesAt: [position, selectedTiles[0]])
            
            gameboard.insertTiles(at: [position, selectedTiles[0]], withValues: [tile_1_newValue, tile_0_newValue])
            delegate?.gameModel(self, didInsertTilesAt: [position, selectedTiles[0]], withValues: [tile_1_newValue, tile_0_newValue])
            
            /// Increase the move count.
            updateNumberMoves()
        
            /// Check if level has been clerad and end the game if necessary.
            if isLevelCleared {
                endGame()
            }
        }
    }
    
    /// Undos a previously executed move.
    func undoMove() {
        guard let lastPerformedMove = state.movesBuffer.popLast() else { return }
        for tilePosition in gameboard.selectedItems() {
            gameboard.markItem(withPosition: tilePosition, asSelected: false)
            delegate?.gameModel(self, didSelectTilesAt: [tilePosition], false)
        }
        
        let positions = [
            (lastPerformedMove[0][0], lastPerformedMove[0][1]),
            (lastPerformedMove[1][0], lastPerformedMove[1][1])
        ]
        let values = [
            lastPerformedMove[0][2],
            lastPerformedMove[1][2]
        ]
        
        /// Restore previous tiles.
        gameboard.removeTiles(from: positions)
        gameboard.insertTiles(at: positions, withValues: values)
        
        delegate?.gameModel(self, didRemoveTilesAt: positions)
        delegate?.gameModel(self, didUndoMoveAt: positions, withValues: values)
        
        /// Increase the move count.
        updateNumberMoves()
    }
    
    /// Reset the game to its initial state and notify the delegate.
    func resetGame() {
        state = GameState(level: state.level)
        gameboard.removeTiles(from: gameboard.positions)
        gameboard.insertTiles(at: gameboard.positions, withValues: state.gridValues)
        delegate?.gameModel(self, didResetLevel: state.level)
        delegate?.gameModel(self, didSelectTilesAt: gameboard.positions, false)
        delegate?.gameModel(self, didUpdateNumberOfMovesTo: 0)
        CoreDataManager.deleteObject(forLevel: state.level)
    }
    
    func saveState() {
        for (i, position) in gameboard.positions.enumerated() {
            state.gridValues[i] = gameboard.getItem(at: position).getValue()
        }
        let payload = state.buildPayload()
        CoreDataManager.save(payload: payload, forLevel: state.level)
    }
    
    /// MARK: - Helper Methods
    
    /// Clears the gameboard and notifies the delegate the game has ended.
    fileprivate func endGame() {
        /// Clear the gameboard.
        gameboard.removeTiles(from: gameboard.positions)
        delegate?.gameModel(self, didCompleteLevel: state.level, withTotalMoves: state.numMoves)
        CoreDataManager.deleteObject(forLevel: state.level)
    }
    
    /// Updates the number of moves and notifies the delegate.
    fileprivate func updateNumberMoves(by value: Int = 1) {
        state.numMoves = state.numMoves + value
        delegate?.gameModel(self, didUpdateNumberOfMovesTo: state.numMoves)
    }
    
}

/// MARK: - Static Constructors
extension GameModel {
    
    /// Setup the gameboard for a new round of PlusUno. That means initializing a 3x3
    /// gameboard and assigning to each entry a TileObject with value 1 everywhere but
    /// the center, where we'll have a TileObject with value of 0.
    static func normalMode(level: Int, delegate: GameModelDelegate? = nil, withState state: GameState? = nil) -> GameModel {
        let model = GameModel()
        model.delegate = delegate
        model.state = state == nil ? GameState(level: level) : state
        model.gameboard = Gameboard<TileObject>(numRows: 3, numCols: 3, initialItems: .Empty)
        model.gameboard.insertTiles(at: model.gameboard.positions, withValues: model.state.gridValues)
        model.delegate?.gameModel(model, didInsertTilesAt: model.gameboard.positions, withValues: model.state.gridValues)
        model.delegate?.gameModel(model, didStartNewGameWithLevel: level)
        
        return model
    }
    
    static func genericMode(level: Int, numRows: Int, numCols: Int, values: [Int], delegate: GameModelDelegate? = nil) -> GameModel {
        let model = GameModel()
        model.delegate = delegate
        model.state = GameState(level: level)
        model.gameboard = Gameboard<TileObject>(numRows: numRows, numCols: numCols, initialItems: .Empty)
        model.gameboard.insertTiles(at: model.gameboard.positions, withValues: values)
        model.delegate?.gameModel(model, didInsertTilesAt: model.gameboard.positions, withValues: values)
        model.delegate?.gameModel(model, didStartNewGameWithLevel: level)
        
        return model
    }
    
}

//
//  AuxiliaryModels.swift
//  PlusUno
//
//  Created by Mario Solano on 10/19/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import Foundation


/// An enum to be used as entries for out gameboard.
enum TileObject {
    case Empty
    case Tile(Int)
    
    func getValue() -> Int {
        switch self {
        case .Empty:
            return -1
        case .Tile(let value):
            return value
        }
    }
}


/// A generic gameboard with entries of type 'T'.
struct Gameboard<T> {
    
    let numCols: Int
    let numRows: Int
    
    lazy var positions: [(Int, Int)] = {
        var positions = [(Int, Int)]()
        for i_row in 0..<self.numRows {
            for j_col in 0..<self.numCols {
                positions.append((i_row, j_col))
            }
        }
        
        return positions
    }()
    
    /// An array representation for our gameboard. Each entry in the gameboard has a tuple (T, Bool)
    /// associated with it. The boolean in the tuple indicates whether its corresponding item of type 'T' has
    /// been selected.
    var boardArray: [(T, Bool)]
    
    /// Initialize the 'boardArray' with 'numRows*numCols' entries and fill it with that many 'initialItems'.
    /// Every entry in the gameboard starts off as 'not selected'.
    ///
    /// - Parameters:
    ///  - numRows: The number of rows in the gameboard.
    ///  - numCols: The number of cols in the gameboard.
    ///  - initialItems: The initial item for each entry in the gameboard.
    init(numRows: Int, numCols: Int, initialItems: T) {
        self.numCols = numCols
        self.numRows = numRows
        boardArray = [(T, Bool)](repeating: (initialItems, false), count: numRows*numCols)
    }
    
    /// Check if the passed row and col are possible entries in the gameboard.
    ///
    /// - Parameters:
    ///  - row: The row position.
    ///  - col: The col position.
    ///
    /// - Returns: true if the row/col pair is valid, false otherwise.
    private func isValidEntry(row: Int, col: Int) -> Bool {
        if !(col >= 0 && col < numCols) { return false }
        if !(row >= 0 && row < numRows) { return false}
        return true
    }
    
    subscript(row: Int, col: Int) -> (T, Bool) {
        get {
            guard isValidEntry(row: row, col: col) else {
                fatalError("Not a valid column and/or row entry.")
            }
            let index = row * numCols + col
            return boardArray[index]
        }
        set {
            guard isValidEntry(row: row, col: col) else {
                fatalError("Not a valid column and/or row entry.")
            }
            let index = row * numCols + col
            boardArray[index] = newValue
        }
    }
    
    /// Marks the item in the gameboard as selected/not-selected.
    ///
    /// - Parameters:
    ///  - select: a flag that indicates whether we are selecting the item or not.
    ///  - position: the position of the item.
    mutating func markItem(withPosition position: (Int, Int), asSelected select: Bool) {
        let (row, col) = position
        self[row, col].1 = select
    }
    
    /// Retrieves an item from the gameboard.
    ///
    /// - Parameters:
    ///  - position: the position in the gameboard of the item.
    ///
    /// - Returns: the item at the indicated position.
    func getItem(at position: (Int, Int)) -> T {
        let (row, col) = position
        return self[row, col].0
    }
    
    /// Retrieves the positions of all selected items in the gameboard.
    ///
    /// - Returns: an array of tuples indicating the positions of the currently selected items.
    mutating func selectedItems() -> [(Int, Int)] {
        var selectedTilesArray = [(Int, Int)]()
        for (row, col) in self.positions {
            if self[row, col].1 {
                selectedTilesArray.append((row, col))
            }
        }
        
        return selectedTilesArray
    }

}

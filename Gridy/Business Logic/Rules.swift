//
//  Rules.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Rules {
  func isWin(_ board: Board) -> Bool {
    return areOrderedImages(on: board)
  }
  
  func areOrderedImages(on board: Board) -> Bool {
    guard board.isFull() else { return false }
    var order = 1
    for row in 1...board.height {
      for column in 1...board.width {
        let position = Position(column: column, row: row)
        guard let imagesOrder = board.getTileId(from: position),
          imagesOrder == order
          else { return false }
        order += 1
      }
    }
    return true
  }
}

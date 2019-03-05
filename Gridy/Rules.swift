//
//  Rules.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Rules {
  func isWin(_ board: Board) -> Bool {
    return board.isFull() && isMatching(board)
  }
  
  func isMatching(_ board: Board) -> Bool {
    var order = 1
    for row in 1...board.height {
      for column in 1...board.width {
        let position = Position(column: column, row: row)
        guard let imagesOrder = board.get(from: position),
          imagesOrder == order
          else { return false }
        order += 1
      }
    }
    return true
  }
}

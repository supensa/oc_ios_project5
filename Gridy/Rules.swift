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
    var imageId = 1
    
    for row in 1...board.height {
      for column in 1...board.width {
        let position = Position(column: column, row: row)
        guard let id = board.get(from: position),
          id == imageId
          else { return false }
        imageId += 1
      }
    }
    
    return true
  }
}

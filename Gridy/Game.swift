//
//  Game.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Game {
  private(set) var startingBoard: Board
  private(set) var finishingBoard: Board
  
  private let rules = Rules()
  
  init(_ starting: Board,
       _ finishing: Board,
       _ imagesOrder: [Int]) {
    finishingBoard = finishing
    startingBoard = starting
    randomlyFill(startingBoard, with: imagesOrder)
  }
  
  convenience init(_ imagesOrder: [Int]) {
    self.init(Board(), Board(), imagesOrder)
  }
  
  func checkForWin() -> Bool {
    return rules.isWin(finishingBoard)
  }
  
  private func randomlyFill(_ board: Board,
                            with imagesOrder: [Int]) {
    var imagesId = imagesOrder
    
    for row in 1...board.height {
      for column in 1...board.width {
        let max = imagesId.count - 1
        let random = max == 0 ? 0 : Int.random(in: 0..<max)
        let image = imagesId.remove(at: random)
        let position = Position(column: column, row: row)
        try! board.place(image, at: position)
      }
    }
  }
}

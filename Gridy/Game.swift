//
//  Game.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Game {
  private(set) var initialBoard: Board
  private(set) var mainBoard: Board
  private(set) var imagesId: [Int]
  
  init(main: Board, initial: Board, imagesOrder: [Int]) {
    initialBoard = initial
    mainBoard = main
    imagesId = imagesOrder
    randomlyFill(initialBoard, with: imagesId)
  }
  
  private func randomlyFill(_ board: Board,
                            with imagesOrder: [Int]) {
    var imagesId = imagesOrder
    
    for row in 1...board.height {
      for column in 1...board.width {
        let max = imagesId.count - 1
        let random = max == 0 ? 0 : Int.random(in: 0..<max)
        let imageId = imagesId.remove(at: random)
        let position = Position(column: column, row: row)
        try! board.place(imageId, at: position)
      }
    }
  }
}

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
  
  func place(_ imageId: Int, at position: Position) {
    do {
      try finishingBoard.place(imageId, at: position)
    } catch {
      let error = error as! BoardError
      switch error {
      case .badPosition:
        // handle error
        break
      case .spaceOccupied:
        break
      }
    }
  }
  
  // TODO: - Move Logic from one board to another
  func move(_ imageId: Int,
            from startPosition: Position,
            to endPosition: Position) {
    place(imageId, at: endPosition)
  }
  
  func isWin() -> Bool {
    return rules.isWin(finishingBoard)
  }
  
  func findAnEmptyCell() -> Position? {
    let board = startingBoard
    for row in 1...board.height {
      for column in 1...board.width {
        let position = Position(column: column, row: row)
        if board.getImageId(from: position) == nil {
          return position
        }
      }
    }
    return nil
  }
  
  private func handleBadPosition(_ imageId: Int) {
    if let position = findAnEmptyCell(),
      let _ = try? startingBoard.place(imageId, at: position) {
      
    } else {
      fatalError("Starting board should have at least one empty cell")
    }
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

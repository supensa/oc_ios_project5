//
//  Game.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Game {
  private var startBoard: Board
  private var answerBoard: Board
  
  private let rules = Rules()
  
  init(_ start: Board,
       _ answer: Board,
       _ imagesOrder: [Int]) {
    answerBoard = answer
    startBoard = start
    randomlyFill(startBoard, with: imagesOrder)
  }
  
  convenience init(_ imagesOrder: [Int]) {
    self.init(Board(), Board(), imagesOrder)
  }
  
  func isWin() -> Bool {
    return rules.isWin(answerBoard)
  }
  
  func move(from provenance: Provenance,
            to position: Position) {
    let isStartingBoard = provenance.boardType == .start
    let board = isStartingBoard ? startBoard : answerBoard
    if let imageId = board.remove(from: provenance.position) {
      move(imageId, from: provenance, to: position)
    }
  }
  
  func placeOnStartBoard(_ imageId: Int) {
    if let position = findAnEmptyCell() {
      try! startBoard.place(imageId, at: position)
    }
  }
  
  private func move(_ imageId: Int,
                     from provenance: Provenance,
                     to position: Position) {
    do {
      try answerBoard.place(imageId, at: position)
    } catch {
      switch error as! BoardError {
      case .badPosition:
        placeOnStartBoard(imageId)
        break
      case .spaceOccupied:
        moveBack(imageId, to: provenance)
        break
      }
    }
  }
  
  private func moveBack(_ imageId: Int,
                        to provenance: Provenance) {
    let isStartingBoard = provenance.boardType == .start
    let board = isStartingBoard ? startBoard : answerBoard
    try! board.place(imageId, at: provenance.position)
  }
  
  private func findAnEmptyCell() -> Position? {
    let board = startBoard
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

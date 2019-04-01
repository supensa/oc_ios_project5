//
//  BoardData.swift
//  Gridy
//
//  Created by Spencer Forrest on 15/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class BoardFactoryImplementation: BoardFactory {
  func makeBoard() -> Board {
    return BoardData()
  }
}

class BoardData: Board {
  private(set) var width: Int
  private(set) var height: Int
  
  init(width: Int = 4, height: Int = 4) {
    self.width = width
    self.height = height
  }
  
  func countTilesPlaced() -> Int {
    return imagesOrder.count
  }
  
  func isFull() -> Bool {
    return imagesOrder.count == cellCount
  }
  
  func getTileId(from position: Position) -> Int? {
    let location = makeLocation(position)
    return imagesOrder[location]
  }
  
  func place(_ imageOrder: Int,
             at position: Position) throws {
    if isOutOfBound(position) {
      throw BoardError.badPosition
    }
    
    let location = makeLocation(position)
    
    if isOccupied(location) {
      throw BoardError.spaceOccupied
    }
    
    imagesOrder[location] = imageOrder
  }
  
  func remove(from position: Position) -> Int? {
    let location = makeLocation(position)
    return imagesOrder.removeValue(forKey: location)
  }
  
  private func isOccupied(_ location: Int) -> Bool {
    return imagesOrder[location] != nil
  }
  
  private func isOutOfBound(_ position: Position) -> Bool {
    let column = position.column
    let row = position.row
    return column <= 0 || column > height || row <= 0 || row > height
  }
  
  private func makeLocation(_ position: Position) -> Int {
    return position.column * width + position.row
  }
  
  private var imagesOrder = [Int : Int]()
  private var cellCount: Int {
    return width * height
  }
}

//
//  Board.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Board {
  private(set) var width: Int
  private(set) var height: Int
  
  private var imagesOrder = [Int : Int]()
  
  init(width: Int = 4, height: Int = 4) {
    self.width = width
    self.height = height
  }
  
  func countImagesPlaced() -> Int {
    return imagesOrder.count
  }
  
  func isFull() -> Bool {
    return imagesOrder.count == width * height
  }
  
  func get(from position: Position) -> Int? {
    let location = makeLocation(position)
    return imagesOrder[location]
  }
  
  func place(_ image: Int,
             at position: Position) throws {
    if isOutOfBound(position) {
      throw BoardError.badPosition
    }
    
    let location = makeLocation(position)
    
    if isOccupied(location) {
      throw BoardError.spaceOccupied
    }
    
    imagesOrder[location] = image
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
}

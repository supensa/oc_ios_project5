//
//  Board.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Board {
  var cellCount: Int {
    return width * height
  }
  
  private(set) var width: Int
  private(set) var height: Int
  
  private var imagesId = [Int : Int]()
  
  init(width: Int = 4, height: Int = 4) {
    self.width = width
    self.height = height
  }
  
  func countImagesPlaced() -> Int {
    return imagesId.count
  }
    
  func isFull() -> Bool {
    return imagesId.count == cellCount
  }
  
  func get(from position: Position) -> Int? {
    let location = makeLocation(position)
    return imagesId[location]
  }
  
  func place(_ imageId: Int,
             at position: Position) throws {
    if isOutOfBound(position) {
      throw BoardError.badPosition
    }
    
    let location = makeLocation(position)
    
    if isOccupied(location) {
      throw BoardError.spaceOccupied
    }
    
    imagesId[location] = imageId
  }
  
  func remove(from position: Position) -> Int? {
    let location = makeLocation(position)
    return imagesId.removeValue(forKey: location)
  }
  
  private func isOccupied(_ location: Int) -> Bool {
    return imagesId[location] != nil
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

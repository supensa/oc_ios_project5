//
//  Board.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

enum BoardError: Error {
  case spaceOccupied
  case badPosition
}

class Board {
  private(set) var width = 4
  private(set) var height = 4
  
  private var imagesId = [Int : Int]()
  
  func countImagesPlaced() -> Int {
    return imagesId.count
  }
  
  func isFull() -> Bool {
    return imagesId.count == width * height
  }
  
  func get(from position: Position) -> Int? {
    let location = makeLocation(position)
    return imagesId[location]
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
    
    imagesId[location] = image
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

//
//  PuzzleGridModel.swift
//  Gridy
//
//  Created by Spencer Forrest on 19/06/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

/// Logic of a Grid:
/// -> Total number of tiles
/// -> Which image is on which tile
/// -> What tiles are free
class PuzzleGridModel {
  typealias Id = Int
  typealias Position = Int
  
  private var dictionary: [Id: Position]
  private var freeTile: [Position:Bool]
  private var numberOftile: Int
  
  init(numberOftile: Int) {
    self.dictionary = [Id:Position]()
    self.freeTile = [Position:Bool]()
    self.numberOftile = numberOftile
    for tile in 0..<numberOftile {
      freeTile[tile] = true
    }
  }
  
  /// Check if the user just won
  ///
  /// - Returns: True if the user completed the puzzle
  func isAwin() -> Bool {
    return isFull() && isMatching()
  }
  
  /// Check if the grid contains the image
  ///
  /// - Parameter id: image's id
  /// - Returns: true if the grid contains the image
  func contains(id: Id) -> Bool {
    return dictionary[id] != nil
  }
  
  /// Get position of image on the grid
  ///
  /// - Parameter id: Image's id
  /// - Returns: Actual position on the grid
  func position(id: Id) -> Int? {
    return dictionary[id]
  }
  
  /// Check if a tile is free at a certain postion
  ///
  /// - Parameter position: Position to check
  /// - Returns: True if the position is free
  func isTileFree(at position: Position) -> Bool {
    if let isFree = freeTile[position] {
      if isFree { return true }
    }
    return false
  }
  
  /// Update position of an image on a tile
  ///
  /// - Parameters:
  ///   - id: image's id
  ///   - position: tile's position
  func updatePosition(id: Id, position: Position?) {
    if let oldPosition = dictionary[id] {
      freeTile[oldPosition] = true
    }
    if let position = position {
      freeTile[position] = false
      dictionary[id] = position
    } else {
      dictionary[id] = nil
    }
  }
  
  /// Check if all the images are on the Grid
  ///
  /// - Returns: True if all images are on the grid
  private func isFull() -> Bool {
    return dictionary.count == numberOftile
  }
  
  /// Check if all images are on the right tile
  ///
  /// - Returns: true puzzle is solved
  private func isMatching() -> Bool{
    for (id, position) in dictionary {
      if id != position { return false }
    }
    return true
  }
}

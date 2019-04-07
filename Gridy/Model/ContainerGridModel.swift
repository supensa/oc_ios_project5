//
//  ContainerGridModel.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/04/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

/// Logic of a Grid:
/// -> Total number of tiles
/// -> Which image is on which tile
/// -> What tiles are free
class ContainerGridModel {
  typealias Id = Int
  typealias Position = Int
  
  private var dictionary: [Id: Position]
  private var emptyTiles: [Position: Bool]
  private var numberOftile: Int
  
  init(numberOftile: Int) {
    self.dictionary = [Id:Position]()
    self.emptyTiles = [Position:Bool]()
    self.numberOftile = numberOftile
    for tile in 0..<numberOftile {
      emptyTiles[tile] = true
    }
  }
  
  /// Gives the position of the first free tile if any
  ///
  /// - Returns: Return position or nil
  func findFirstEmptyTilePosition() -> Int? {
    for position in 0..<emptyTiles.count {
      if let isFree = emptyTiles[position] {
        if isFree { return position }
      }
    }
    return nil
  }
  
  /// Update position of an image on a tile
  ///
  /// - Parameters:
  ///   - id: image's id
  ///   - position: tile's position
  func updatePosition(id: Id, position: Position?) {
    if let oldPosition = dictionary[id] {
      emptyTiles[oldPosition] = true
    }
    if let position = position {
      emptyTiles[position] = false
      dictionary[id] = position
    } else {
      dictionary[id] = nil
    }
  }
}

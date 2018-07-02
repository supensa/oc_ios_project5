//
//  GridModel.swift
//  Gridy
//
//  Created by Spencer Forrest on 19/06/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

class GridModel {
  typealias Id = Int
  typealias Position = Int
  
  private var dictionary: [Id:Position]
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
  
  func isMatching() -> Bool{
    for (id, position) in dictionary {
      if id != position { return false }
    }
    return true
  }
  
  func isFull() -> Bool {
    return dictionary.count == numberOftile
  }
  
  func position(id: Id) -> Int? {
    return dictionary[id]
  }
  
  func isTileFree(at position: Position) -> Bool {
    if let isFree = freeTile[position] {
      if isFree { return true }
    }
    return false
  }
  
  func getFreeTilePosition() -> Int? {
    for position in 0..<freeTile.count {
      if let isFree = freeTile[position] {
        if isFree { return position }
      }
    }
    return nil
  }
  
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
}

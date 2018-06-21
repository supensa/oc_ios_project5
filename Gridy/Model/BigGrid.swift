//
//  BigGrid.swift
//  Gridy
//
//  Created by Spencer Forrest on 19/06/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

class BigGrid {
  typealias Id = Int
  typealias Position = Int
  
  private var dictionary: [Id:Position]
  private var freeTile: [Position:Bool]
  
  init(numberOftile: Int) {
    self.dictionary = [Id:Position]()
    self.freeTile = [Position:Bool]()
    for tile in 0..<numberOftile {
      freeTile[tile] = true
    }
  }
  
  func getPosition(id: Id) -> Int? {
    return dictionary[id]
  }
  
  func isTileFree(at position: Position) -> Bool {
    if let isFree = freeTile[position] {
      if isFree { return true }
    }
    return false
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

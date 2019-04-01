//
//  Board.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

protocol Board {
  var width: Int { get }
  var height: Int { get }
  func countTilesPlaced() -> Int
  func isFull() -> Bool
  func getTileId(from position: Position) -> Int?
  func place(_ imageOrder: Int, at position: Position) throws
  func remove(from position: Position) -> Int?
}

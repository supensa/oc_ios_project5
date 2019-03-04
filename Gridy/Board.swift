//
//  Board.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

class Board {
  private let width = 4
  private let height = 4
  
  private var images = [Int : Int]()
  
  func countImagesPlaced() -> Int {
    return images.count
  }
  
  func place(_ column: Int,
             _ row: Int,
             _ image: Int) {
    let key = makeLocation(column, row)
    images[key] = image
  }
  
  func get(_ column: Int,
           _ row: Int) -> Int? {
    let location = makeLocation(column, row)
    return images[location]
  }
  
  func makeLocation(_ column: Int,
                           _ row: Int) -> Int {
    return column * width + row
  }
}

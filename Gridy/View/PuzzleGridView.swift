//
//  PuzzleGridView.swift
//  Gridy
//
//  Created by Spencer Forrest on 10/05/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class PuzzleGridView: UIView {
  private var tiles = [UIView]()
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init() {
    super.init(frame: .zero)
    backgroundColor = UIColor.janna
    initializeAndSetTiles()
    addTilesAsSubviews()
  }
  
  func findTilePositionContaining(_ point: CGPoint) -> Int? {
    for i in 0...tiles.count - 1 {
      let tile = tiles[i]
      if tile.frame.contains(point) {
        return i
      }
    }
    return nil
  }
  
  func getTile(from position: Int) -> UIView? {
    guard position < tiles.count else { return nil }
    return tiles[position]
  }
  
  override func layoutSubviews() {
    let boundSize = min(bounds.width, bounds.height)
    let tileMargin: CGFloat = 2
    let tilesPerRow = 4
    let tilesPerColumn = 4
    
    let totalMarginPerRow = tileMargin * CGFloat(tilesPerRow) + tileMargin
    
    let tileWidth = (boundSize - totalMarginPerRow) / CGFloat(tilesPerRow)
    let tileHeight = tileWidth
    
    var index = 0
    for row in 0...tilesPerRow - 1 {
      
      for column in 0...tilesPerColumn - 1 {
        
        let tile = tiles[index]
        
        let row = CGFloat(row)
        let column = CGFloat(column)
        
        let xPosition = column * tileWidth + CGFloat(tileMargin) * column + tileMargin
        let yPosition = row * tileHeight + CGFloat(tileMargin) * row + tileMargin
        
        tile.frame = CGRect(x: xPosition,
                            y: yPosition,
                            width: tileWidth,
                            height: tileHeight)
        index += 1
      }
    }
  }
  
  private func initializeAndSetTiles() {
    for _ in 1...16 {
      let tile = UIView()
      tile.backgroundColor = UIColor.white
      tiles.append(tile)
      addSubview(tile)
    }
  }
  
  private func addTilesAsSubviews() {
    for tile in tiles {
      addSubview(tile)
    }
  }
}

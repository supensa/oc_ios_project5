//
//  GridView.swift
//  Gridy
//
//  Created by Spencer Forrest on 10/05/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol GridViewDataSource: AnyObject {
  func numberOfTiles(gridView tag: Int) -> Int
  func numberOfTilesPerRow(gridView tag: Int) -> Int
  func getTile(at index: Int) -> UIView
}

protocol GridViewDelegate: AnyObject {
  func gapLength(gridView tag: Int) -> CGFloat
}

class GridView: UIView {
  weak var datasource: GridViewDataSource?
  weak var delegate: GridViewDelegate?
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  init(tag: Int) {
    super.init(frame: CGRect())
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = GridyColor.pixieGreen
    self.tag = tag
  }
  
  override func layoutSubviews() {
    var tileCount = 0
    if let count = datasource?.numberOfTiles(gridView: tag) {
      tileCount = count
    }
    
    for index in 0..<tileCount {
      guard let tile = datasource?.getTile(at: index) else { continue }
      tile.translatesAutoresizingMaskIntoConstraints = true
      if self.subviews.count < tileCount {
        self.addSubview(tile)
      }
    }
    
    let size = getTileSize()
    
    let origins = calculateOrigins(size: size, tileCount: tileCount)
    
    // Set frame and origin of each tile
    for index in 0..<tileCount {
      let tile = self.subviews[index]
      let origin = origins[index]
      tile.frame = CGRect.init(origin: origin, size: size)
    }
  }
  
  func getTileSize() -> CGSize {
    var size = CGSize(width: 44, height: 44)
    if let number =  self.datasource?.numberOfTilesPerRow(gridView: tag),
      let gap = delegate?.gapLength(gridView: tag) {
      let tilePerRow = CGFloat(number)
      let tilePerColumn = CGFloat(numberOfRows())
      let width = (self.frame.width - gap * (tilePerRow + 1)) / tilePerRow
      let height = (self.frame.height - gap * (tilePerColumn + 1)) / tilePerRow
      size = CGSize(width: width, height: height)
    }
    return size
  }
  
  private func calculateOrigins(size: CGSize, tileCount: Int) -> [CGPoint] {
    let numberOfRows = self.numberOfRows()
    var gapLength: CGFloat = 0
    if let gap = delegate?.gapLength(gridView: tag) {
      gapLength = gap
    }
    var tilesPerRow = 1
    if let number = datasource?.numberOfTilesPerRow(gridView: tag) {
      tilesPerRow = number
    }
    // Calculate origin point for each tile
    var origins = [CGPoint]()
    var count = 0
    for row in 0..<numberOfRows {
      let y = size.height * CGFloat(row) + gapLength * CGFloat(row + 1)
      for column in 0..<tilesPerRow {
        let x = size.width * CGFloat(column) + gapLength * CGFloat(column + 1)
        origins.append(CGPoint(x: x, y: y))
        count += 1
        if count == tileCount { break }
      }
    }
    return origins
  }
  
  private func numberOfRows() -> Int {
    var numberOfRows: CGFloat = 1
    if let tilesCount = datasource?.numberOfTiles(gridView: tag),
      let tilesPerRow = datasource?.numberOfTilesPerRow(gridView: tag) {
      numberOfRows = CGFloat(tilesCount) / CGFloat(tilesPerRow)
    }
    numberOfRows = numberOfRows.rounded(.up)
    return Int(numberOfRows)
  }
}

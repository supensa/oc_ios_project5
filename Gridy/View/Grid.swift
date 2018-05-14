//
//  GridView.swift
//  Gridy
//
//  Created by Spencer Forrest on 18/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol GridDataSource: AnyObject {
  func numberOfTiles(gridView tag: Int) -> Int
  func numberOfTilesPerRow(gridView tag: Int) -> Int
  func getTiles(at index: Int) -> UIView
}

protocol GridDelegate: AnyObject {
  /// Override it to provide the length of gaps between tiles
  /// Default implementation returns '0'
  ///
  /// - Parameter in: GridView to access "tag"
  /// - Returns: length of gaps in CGFloat
  func gapLength(gridView tag: Int) -> CGFloat
  func getTileSize() -> CGSize
}

class Grid: UIView {
  
  weak var delegate: GridDelegate?
  weak var dataSource: GridDataSource?
  
  private(set) var tiles: [UIView]!
  
  private var tilesCount: Int! {
    return self.dataSource?.numberOfTiles(gridView: tag)
  }
  
  private var tilesPerRow: Int! {
    return self.dataSource?.numberOfTilesPerRow(gridView: tag)
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(tag: Int = 0) {
    super.init(frame: CGRect())
    self.tag = tag
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.cyan
    self.tiles = [UIView]()
  }
  
  override func layoutSubviews() {
    let gapLength = self.delegate?.gapLength(gridView: tag)
    self.layoutTilesInBounds(numberOfRows: numberOfRows(), gapLength: gapLength!)
  }
  
  private func numberOfRows() -> Int {
    var numberOfRows = CGFloat(self.tilesCount) / CGFloat(self.tilesPerRow)
    numberOfRows = numberOfRows.rounded(.up)
    return Int(numberOfRows)
  }
  
  private func instantiateTiles() {
    self.tiles = [UIView]()
    let max = self.tilesCount - 1
    for index in 0...max {
      let view = dataSource?.getTiles(at: index)
      view?.translatesAutoresizingMaskIntoConstraints = true
      self.tiles.append(view!)
      addSubview(self.tiles[index])
    }
  }
  
  private func layoutTilesInBounds(numberOfRows: Int, gapLength: CGFloat) {
    let sizes = delegate?.getTileSize()
    let size = sizes!
    var tileIndex = 0
    
    if self.subviews.count != tilesCount {
      for view in self.subviews {
        view.removeFromSuperview()
      }
    }
    
    for row in 0..<numberOfRows {
      let y = size.height * CGFloat(row) + gapLength * CGFloat(row)
      for column in 0..<self.tilesPerRow {
        let x = size.width * CGFloat(column) + gapLength * CGFloat(column)
        let origin = CGPoint(x: x, y: y)
        tiles[tileIndex].frame = CGRect.init(origin: origin, size: size)
        tileIndex += 1
        if tileIndex == tiles.count { break }
      }
    }
  }
}

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
  func eyeImageViewTapped()
}

class GridView: UIView {
  weak var datasource: GridViewDataSource?
  weak var delegate: GridViewDelegate?
  
  var isLandscape: Bool!
  var tilesFrame: [CGRect]!
  var eyeOption: Bool!
  
  private var eyeImageView: UIImageView?
  private var eyeImageViewWidthAnchor: NSLayoutConstraint?
  private var eyeImageViewHeightAnchor: NSLayoutConstraint?
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  init(tag: Int, eyeOption: Bool = false) {
    super.init(frame: .zero)
    self.tag = tag
    self.eyeOption = eyeOption
    tilesFrame = [CGRect]()
    isLandscape = true
    if eyeOption {
      let image = UIImage(named: "eye")
      self.eyeImageView = UIImageView(image: image)
      eyeImageView?.translatesAutoresizingMaskIntoConstraints = false
      eyeImageView?.isUserInteractionEnabled = true
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eyeImageViewTapped))
      eyeImageView?.addGestureRecognizer(tapGestureRecognizer)
    }
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
    
    let tileSize = getTileSize()
    
    let origins = calculateOrigins(size: tileSize, tileCount: tileCount)
    
    tilesFrame.removeAll()
    
    // Set frame and origin of each tile
    for index in 0..<tileCount {
      let tile = self.subviews[index]
      let origin = origins[index]
      let frame = CGRect.init(origin: origin, size: tileSize)
      tile.frame = frame
      tilesFrame.append(frame)
    }
    updateEyeImageView()
  }
  
  @objc func eyeImageViewTapped() {
    delegate?.eyeImageViewTapped()
  }
  
  func getTileSize() -> CGSize {
    var size = CGSize(width: 44, height: 44)
    if let number =  self.datasource?.numberOfTilesPerRow(gridView: tag),
      let gap = delegate?.gapLength(gridView: tag) {
      let tilePerRow = CGFloat(number)
      let width = (self.frame.width - gap * (tilePerRow + 1)) / tilePerRow
      // Tiles are squares
      size = CGSize(width: width, height: width)
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
  
  func numberOfRows() -> Int {
    var numberOfRows: CGFloat = 1
    if let tilesCount = datasource?.numberOfTiles(gridView: tag),
      let tilesPerRow = datasource?.numberOfTilesPerRow(gridView: tag) {
      numberOfRows = CGFloat(tilesCount) / CGFloat(tilesPerRow)
    }
    numberOfRows = numberOfRows.rounded(.up)
    return Int(numberOfRows)
  }
  
  func updateEyeImageView() {
    guard let view = eyeImageView else { return }
    if !view.isDescendant(of: self) {
      self.addSubview(view)
      if let gapLength = delegate?.gapLength(gridView: tag) {
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -gapLength).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -gapLength).isActive = true
      }
    }
    
    if eyeImageViewWidthAnchor != nil && eyeImageViewHeightAnchor != nil {
      eyeImageViewWidthAnchor?.isActive = false
      eyeImageViewHeightAnchor?.isActive = false
    }
    
    let tileLength: CGFloat = getTileSize().width
    
    if tileLength > 0 {
      let height = tileLength * 1
      let width = tileLength * 2
      
      eyeImageViewWidthAnchor = eyeImageView?.widthAnchor.constraint(equalToConstant: width)
      eyeImageViewHeightAnchor = eyeImageView?.heightAnchor.constraint(equalToConstant: height)
      
      eyeImageViewWidthAnchor?.isActive = true
      eyeImageViewHeightAnchor?.isActive = true
    }
  }
}

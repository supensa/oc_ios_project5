//
//  ContainerGridView.swift
//  Gridy
//
//  Created by Spencer Forrest on 02/04/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit

protocol ContainerGridViewDelegate: AnyObject {
  func eyeViewTapped()
}

class ContainerGridView: UIView {
  private var tiles = [UIView]()
  private var eyeView: UIImageView!
  
  weak var delegate: ContainerGridViewDelegate?
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init() {
    super.init(frame: .zero)
    
    initializeAndSetTiles()
    addTilesAsSubviews()
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eyeViewTapped))
    let image = UIImage(named: Constant.ImageName.eye)
    eyeView = UIImageView(image: image)
    eyeView.contentMode = .scaleAspectFit
    
    addSubview(eyeView)
    setupLayoutEyeView()
    
    eyeView.isUserInteractionEnabled = true
    eyeView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc private func eyeViewTapped() {
    delegate?.eyeViewTapped()
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
    layoutTiles()
  }
  
  private func setupLayoutEyeView() {
    guard let lastTile = tiles.last else { fatalError("Cannot layout eyeView") }
    NSLayoutConstraint.setAndActivate([
      eyeView.leftAnchor.constraint(equalTo: lastTile.rightAnchor, constant: 3),
      eyeView.centerYAnchor.constraint(equalTo: lastTile.centerYAnchor),
      eyeView.widthAnchor.constraint(equalTo: lastTile.widthAnchor, multiplier: 2),
      eyeView.heightAnchor.constraint(equalTo: lastTile.heightAnchor, multiplier: 0.8),
      ])
  }
  
  private func layoutTiles() {
    let boundSize = max(bounds.width, bounds.height)
    let tileMargin: CGFloat = 3
    let columnsCount = 6
    let rowCount = 3
    
    let totalMarginPerRow = tileMargin *  CGFloat(columnsCount - 1)
    
    let tileWidth = (boundSize - totalMarginPerRow) / CGFloat(columnsCount)
    let tileHeight = tileWidth
    
    var index = 0
    for row in 0...rowCount - 1 {
      
      for column in 0...columnsCount - 1 {
        guard index < tiles.count else { return }
        
        let tile = tiles[index]
        
        let row = CGFloat(row)
        let column = CGFloat(column)
        
        let xPosition = column * tileWidth + CGFloat(tileMargin) * column
        let yPosition = row * tileHeight + CGFloat(tileMargin) * row
        
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
      tile.layer.borderWidth = 2
      tile.layer.borderColor = UIColor.janna.cgColor
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

//
//  Position.swift
//  Gridy
//
//  Created by Spencer Forrest on 09/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class Position {
  private var safeArea: UIEdgeInsets
  private var height: CGFloat
  private var width: CGFloat
  private var isLandscape: Bool
  private var gapLength: CGFloat = 0
  private var allGaps: CGFloat
  private var countInRow: CGFloat = 0
  private var length: CGFloat = 0
  private var allSquares: CGFloat
  private var offset: CGFloat
  private var marginX: CGFloat = 0
  private var marginY: CGFloat = 0
  private var numberSquares: Int = 0
  
  var margin: CGFloat {
    return isLandscape ? marginX : marginY
  }
  
  init(parentView: UIView, isEditingView: Bool, forSmallSquares: Bool = false, margin: CGFloat = 0) {
    safeArea = (parentView.superview?.safeAreaInsets)!
    height = UIScreen.main.bounds.height - safeArea.top - safeArea.bottom
    width = UIScreen.main.bounds.width - safeArea.right - safeArea.left
    isLandscape = width > height
    countInRow = forSmallSquares ? 6 : 4
    gapLength = forSmallSquares ? 5 : 1
    allGaps = gapLength * (countInRow - 1)
    length = isLandscape ? (height * 0.9 - allGaps) / countInRow : (width * 0.9 - allGaps) / countInRow
    length = isLandscape && forSmallSquares ? (margin * 0.9 - allGaps) / countInRow : length
    allSquares = length * countInRow + allGaps
    offset = isLandscape ? height * 0.05 : width * 0.05
    length = ceil(length)
    calculateMargins(forSmallSquares: forSmallSquares, isEditView: isEditingView)
  }
  
  func getSquares() -> [CGRect] {
    return getSquares(borderWidth: 0)
  }
  
  func getContainerSquares() -> [CGRect] {
    return getSquares(borderWidth: 1)
  }
  
  private func getSquares(borderWidth: CGFloat) -> [CGRect] {
    var rectangles = [CGRect]()
    numberSquares = 16
    var row: CGFloat = 0
    var column: CGFloat = 0
    
    for _ in 0..<numberSquares {
      let x: CGFloat = marginX + length * column + column * gapLength
      let y: CGFloat = marginY + length * row + row * gapLength
      let borderWidth: CGFloat = borderWidth
      let square = CGRect(origin: .init(x: x - borderWidth , y: y - borderWidth),
                          size: CGSize(width: length + borderWidth, height: length + borderWidth))
      rectangles.append(square)
      
      if column == countInRow - 1 {
        column = 0
        row += 1
      } else {
        column += 1
      }
    }
    return rectangles
  }
  
  private func calculateMargins(forSmallSquares: Bool, isEditView: Bool) {
    if forSmallSquares && !isEditView {
      marginX = isLandscape ? 16 : ((width - allSquares) / 2)
      marginY = 70
    } else {
      marginX = !isLandscape || isEditView ? ((width - allSquares) / 2) : width - allSquares - offset
      marginY = isLandscape || isEditView ? ((height - allSquares) / 2) : height - allSquares - offset
    }
  }
}

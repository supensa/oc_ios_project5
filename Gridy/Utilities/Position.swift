//
//  Position.swift
//  Gridy
//
//  Created by Spencer Forrest on 09/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class Position {
  static private var safeArea: UIEdgeInsets!
  static private var height: CGFloat!
  static private var width: CGFloat!
  static private var isLandscape: Bool!
  static private var gapLength: CGFloat!
  static private var allGaps: CGFloat!
  static private var countInRow: CGFloat!
  static private var length: CGFloat!
  static private var allSquares: CGFloat!
  static private var offset: CGFloat!
  static private var marginX: CGFloat!
  static private var marginY: CGFloat!
  
  static func rectanglesIn(parentView: UIView, isEditingView: Bool = true, forSmallSquares: Bool = true) -> [CGRect] {
    calculate(parentView: parentView, isEditingView: isEditingView, forSmallSquares: forSmallSquares)
    return getRectangles()
  }
  
  static private func calculate(parentView: UIView, isEditingView: Bool, forSmallSquares: Bool) {
    safeArea = (parentView.superview?.safeAreaInsets)!
    height = UIScreen.main.bounds.height - safeArea.top - safeArea.bottom
    width = UIScreen.main.bounds.width - safeArea.right - safeArea.left
    isLandscape = width > height
    countInRow = forSmallSquares ? 6 : 4
    gapLength = forSmallSquares ? 5 : 1
    allGaps = gapLength * (countInRow - 1)
    length = isLandscape ? (height * 0.9 - allGaps) / countInRow : (width * 0.9 - allGaps) / countInRow
    allSquares = length * countInRow + allGaps
    offset = isLandscape ? height * 0.05 : width * 0.05
    if forSmallSquares {
      marginX = !isLandscape || isEditingView ? ((width - allSquares) / 2) : width - allSquares - offset
      marginY = isLandscape || isEditingView ? ((height - allSquares) / 2) : height - allSquares - offset
    } else {
      marginX = !isLandscape || isEditingView ? ((width - allSquares) / 2) : width - allSquares - offset
      marginY = isLandscape || isEditingView ? ((height - allSquares) / 2) : height - allSquares - offset
    }
    length = ceil(length)
  }
  
  static private func getRectangles() -> [CGRect] {
    var rectangles = [CGRect]()
    let numberSquares = 16
    var row: CGFloat = 0
    var column: CGFloat = 0
    
    for _ in 0..<numberSquares {
      let x: CGFloat = marginX + length * column + column * gapLength
      let y: CGFloat = marginY + length * row + row * gapLength
      let square = CGRect(origin: .init(x: x , y: y),
                          size: CGSize(width: length, height: length))
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
}

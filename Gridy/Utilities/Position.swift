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
  static private var countInRow: CGFloat!
  static private var length: CGFloat!
  static private var allSquareSize: CGFloat!
  static private var offset: CGFloat!
  static private var marginX: CGFloat!
  static private var marginY: CGFloat!
  
  static func rectanglesIn(parentView: UIView, isEditingView: Bool = true, forSmallSquares: Bool = false) -> [CGRect] {
    safeArea = (parentView.superview?.safeAreaInsets)!
    height = UIScreen.main.bounds.height - safeArea.top - safeArea.bottom
    width = UIScreen.main.bounds.width - safeArea.right - safeArea.left
    isLandscape = width > height
    countInRow = forSmallSquares ? 6 : 4
    length = isLandscape ? height * 0.9 / countInRow : width * 0.9 / countInRow
    allSquareSize = length * countInRow + countInRow - 1
    offset = isLandscape ? height * 0.05 : width * 0.05
    if forSmallSquares {
//      marginX =
//      marginY =
    } else {
      marginX = !isLandscape || isEditingView ? ((width - allSquareSize) / 2) : width - allSquareSize - offset
      marginY = isLandscape || isEditingView ? ((height - allSquareSize) / 2) : height - allSquareSize - offset
    }
    length = ceil(length)
    return calculate()
  }
  
  static private func calculate() -> [CGRect] {
    var rectangles = [CGRect]()
    let numberSquares = 16
    var row: CGFloat = 0
    var column: CGFloat = 0
    
    for _ in 0..<numberSquares {
      let square = CGRect(origin: .init(x: marginX + length * column + column, y: marginY + length * row + row),
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

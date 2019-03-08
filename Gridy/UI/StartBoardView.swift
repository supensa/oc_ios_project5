//
//  StartBoardView.swift
//  Gridy
//
//  Created by Spencer Forrest on 08/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit

class StartBoardView: UIView {
  
  private var cellCount: Int
  
  init(frame: CGRect = .zero, cellCount: Int) {
    self.cellCount = cellCount
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupViews() {
    let first = findDivisor()!
    let second = findQuotient(divisor: first)
    let row = min(first, second)
    let column = max(first, second)
    
    print(row)
    print(column)
  }
  
  private func findQuotient(divisor: CGFloat) -> CGFloat {
    return (CGFloat(cellCount)/divisor).rounded(.up)
  }
  
  private func findDivisor() -> CGFloat? {
    for i in 1...cellCount {
      let remainder = cellCount % i
      let isEnoughSpaceForEyeButton = remainder > 0 && (i - remainder) > 1
      if isEnoughSpaceForEyeButton {
        return CGFloat(i)
      }
    }
    return nil
  }
}

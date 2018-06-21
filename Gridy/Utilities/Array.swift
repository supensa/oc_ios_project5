//
//  Array.swift
//  Gridy
//
//  Created by Spencer Forrest on 21/01/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

extension Array {
  /// Provide a random element from the array.
  /// Return nil if the array is empty
  ///
  /// - Returns: Element or nil
  func random() -> Element? {
    if self.isEmpty { return nil }
    let index = Int.random(min: 0, max: self.count - 1)
    return self[index]
  }
  
  /// Pop a random element from the array
  ///
  /// - Returns: Element or nil
  mutating func randomPop() -> Element? {
    if self.isEmpty { return nil }
    let index = Int.random(min: 0, max: self.count-1)
    return self.remove(at: index)
  }
}

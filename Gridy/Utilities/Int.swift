//
//  Int.swift
//  Gridy
//
//  Created by Spencer Forrest on 15/01/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import Foundation

extension Int {
  /// Return a random Int
  ///
  /// - Parameters:
  ///   - min: Minimum value possible
  ///   - max: Maximun value possible
  /// - Returns: Ramdom Integer
  static func random(min: Int = Int.min, max: Int = Int.max) -> Int {
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
  }
}

//
//  UIColor.swift
//  Gridy
//
//  Created by Spencer Forrest on 19/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

extension UIColor {
  static let vistaBlue = UIColor.createFromRGB(136, 212, 152)
  static let pixieGreen = UIColor.createFromRGB(198, 218, 191)
  static let janna = UIColor.createFromRGB(243, 233, 210)
  static let elm = UIColor.createFromRGB(26, 147, 111)
  static let eden = UIColor.createFromRGB(17, 75, 95)
  static let olsoGray = UIColor.createFromRGB(149, 152, 154)
  static let transparent = UIColor.white.withAlphaComponent(0.85)
  
  
  /// Facilitate the use of RGB
  ///
  /// - Parameters:
  ///   - red: a value from 0 to 255
  ///   - green: a value from 0 to 255
  ///   - blue: a value from 0 to 255
  ///   - alpha: a value from 0 to 1
  /// - Returns: A color
  static func createFromRGB(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
    return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
  }
}

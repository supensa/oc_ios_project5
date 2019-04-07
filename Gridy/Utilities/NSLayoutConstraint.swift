//
//  NSLayoutConstraint.swift
//  Gridy
//
//  Created by Spencer Forrest on 02/04/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
  
  class func setAndActivate(_ constraints: [NSLayoutConstraint]) {
    for constraint in constraints {
      if let view = constraint.firstItem as? UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        constraint.isActive = true
      }
    }
  }
  
}

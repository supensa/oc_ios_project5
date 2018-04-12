//
//  View.swift
//  Gridy
//
//  Created by Spencer Forrest on 11/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class View: UIView {
  private(set) var position: Int!
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(position: Int? = nil) {
    super.init(frame: CGRect())
    if let position = position { self.position = position }
  }
}

//
//  ImageView.swift
//  Gridy
//
//  Created by Spencer Forrest on 07/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
  
  private var position: Int!
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
  
  init(image: UIImage? = nil, position: Int? = nil) {
    super.init(image: image)
    self.translatesAutoresizingMaskIntoConstraints = false
    if let position = position { self.position = position }
    self.backgroundColor = UIColor.white
    self.layer.borderColor = GridyColor.janna.cgColor
  }
  
  func isSamePosition(position: Int) -> Bool {
    guard self.position != nil else { return false }
    return self.position == position
  }
}

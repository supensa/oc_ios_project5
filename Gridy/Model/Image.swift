//
//  Image.swift
//  Gridy
//
//  Created by Spencer Forrest on 11/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class Image {
  
  private(set) var image: UIImage!
  private(set) var originalPosition: Int!
  var actualPosition: Int!
  
  init(image: UIImage, position: Int) {
    self.originalPosition = position
    self.actualPosition = position
    self.image = image
  }
}

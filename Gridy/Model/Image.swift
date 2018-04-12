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
  private(set) var position: Int!
  
  init(image: UIImage, position: Int) {
    self.position = position
    self.image = image
  }
}

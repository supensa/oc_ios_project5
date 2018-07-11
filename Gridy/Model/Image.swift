//
//  Image.swift
//  Gridy
//
//  Created by Spencer Forrest on 11/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit


/// Represent a UIImage and its original position
class Image {
  private(set) var image: UIImage
  private(set) var id: Int
  
  init(image: UIImage, id: Int) {
    self.image = image
    self.id = id
  }
}

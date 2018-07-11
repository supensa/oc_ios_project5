//
//  ImageView.swift
//  Gridy
//
//  Created by Spencer Forrest on 07/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
  
  override init(image: UIImage? = nil) {
    super.init(image: image)
    self.image = image
    self.translatesAutoresizingMaskIntoConstraints = true
    self.isUserInteractionEnabled = true
    self.contentMode = .scaleAspectFit
    self.backgroundColor = UIColor.olsoGray
  }
  
  func animate(frame: CGRect) {
    let animation = { self.frame = frame }
    UIView.animate(withDuration: 0.7, animations: animation)
  }
}

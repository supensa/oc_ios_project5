//
//  Button.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class Button: UIButton {
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  private var heightConstraint: NSLayoutConstraint!
  private var widthConstraint: NSLayoutConstraint!
  
  init(imageName: String, forIpad: Bool = false) {
    super.init(frame: CGRect())
    
    let image = UIImage.init(named: imageName)
    self.setImage(image, for: .normal)
    self.imageView?.contentMode = .scaleAspectFit
    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.cornerRadius = K.Layout.cornerRadius.introButton
    self.layer.masksToBounds = true
    self.isUserInteractionEnabled = true
    self.backgroundColor = GridyColor.janna
  }
  
  func setupSizeConstraint(forIpad: Bool) {
    if heightConstraint == nil && widthConstraint == nil {
      let width = forIpad ? K.Layout.Width.button * 1.5 : K.Layout.Width.button
      let height = forIpad ? K.Layout.Height.button * 1.5 : K.Layout.Height.button
      
      self.heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
      self.widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
      
      self.heightConstraint.isActive = true
      self.widthConstraint.isActive = true
    }
  }
}

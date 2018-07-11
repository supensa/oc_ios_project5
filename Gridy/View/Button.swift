//
//  Button.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class Button: UIButton {
  
  private var heightConstraint: NSLayoutConstraint!
  private var widthConstraint: NSLayoutConstraint!
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(imageName: String, forIpad: Bool = false) {
    super.init(frame: .zero)
    
    let image = UIImage.init(named: imageName)
    self.setImage(image, for: .normal)
    self.imageView?.contentMode = .scaleAspectFit
    self.translatesAutoresizingMaskIntoConstraints = false
    self.layer.cornerRadius = Constant.Layout.cornerRadius.introButton
    self.layer.masksToBounds = true
    self.isUserInteractionEnabled = true
    self.backgroundColor = UIColor.janna
  }
  
  func setupSizeConstraint(forIpad: Bool) {
    if heightConstraint == nil && widthConstraint == nil {
      let width = forIpad ? Constant.Layout.Width.button * 1.5 : Constant.Layout.Width.button
      let height = forIpad ? Constant.Layout.Height.button * 1.5 : Constant.Layout.Height.button
      
      self.heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
      self.widthConstraint = self.widthAnchor.constraint(equalToConstant: width)
      
      self.heightConstraint.isActive = true
      self.widthConstraint.isActive = true
    }
  }
}

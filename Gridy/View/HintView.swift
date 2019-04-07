//
//  HintView.swift
//  Gridy
//
//  Created by Spencer Forrest on 08/06/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class HintView: UIView {
  
  var imageView: UIImageView!
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  init(image: UIImage) {
    super.init(frame: .zero)
    
    self.imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(imageView)
    imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    
    self.imageView.alpha = 0
    self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    self.isUserInteractionEnabled = false
  }
  
  func appearsTemporarily(for delay: TimeInterval) {
    self.isUserInteractionEnabled = true
    let fadingInAnimation = {
      self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
      self.imageView.alpha = 1.0
    }
    
    UIView.animate(withDuration: 0.7, animations: fadingInAnimation) {
      (done) in
      if done {
        let fadingOutAnimation = {
          self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
          self.imageView.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.7, delay: delay, options: [], animations: fadingOutAnimation) {
          (completed) in
          if completed {
            self.isUserInteractionEnabled = false
          }
        }
      }
    }
  }
}

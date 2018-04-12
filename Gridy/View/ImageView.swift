//
//  ImageView.swift
//  Gridy
//
//  Created by Spencer Forrest on 07/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
  
  private(set) var defaultImage: Image!
  private var defaultView: View!
  private var actualView: View!
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
  
  init(defaultImage: Image) {
    super.init(image: defaultImage.image)
    self.defaultImage = defaultImage
    self.image = defaultImage.image
    self.translatesAutoresizingMaskIntoConstraints = true
    self.isUserInteractionEnabled = true
    self.contentMode = .scaleAspectFit
    self.backgroundColor = GridyColor.olsoGray
  }
  
  func set(ContainerView view: View) {
    if self.defaultView == nil {
      self.defaultView = view
    }
    self.actualView = view
  }
  
  func change(ContainerView view: View) -> Bool {
    var isDifferentView = false
    if view.position != self.actualView.position {
      isDifferentView = true
      self.actualView = view
    }
    position()
    return isDifferentView
  }
  
  func position() {
    self.adjustFrame(frame: self.actualView.frame)
  }
  
  func resetFrame() -> Bool {
    var isDifferentView = false
    if self.actualView.position != nil {
      isDifferentView = true
      self.actualView = self.defaultView
    }
    let animation = {
      self.frame = self.defaultView.frame
    }
    UIView.animate(withDuration: 0.7, animations: animation)
    return isDifferentView
  }
  
  private func adjustFrame(frame: CGRect) {
    let width = frame.width - 1
    let height = frame.height - 1
    let x = frame.minX + 1
    let y = frame.minY + 1
    self.frame = CGRect(x: x, y: y, width: width, height: height)
  }
}

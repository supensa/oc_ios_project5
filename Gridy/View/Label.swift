//
//  Label.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//#imageLiteral(resourceName: "Logo@2x.png")

import UIKit

class Label: UILabel {
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(text: String?, fontSize: CGFloat, useCustomFont: Bool = false) {
    super.init(frame: .zero)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.text = text
    self.baselineAdjustment = .alignCenters
    self.textAlignment = .center
    self.textColor = useCustomFont ? UIColor.vistaBlue : UIColor.black
    
    let fontName = useCustomFont ? Constant.Font.Name.timeBurner : Constant.Font.Name.helveticaNeue
    
    let font = UIFont.init(name: fontName, size: fontSize)!
    self.font = font
    self.minimumScaleFactor = 0.1
    self.adjustsFontSizeToFitWidth = true
  }
}

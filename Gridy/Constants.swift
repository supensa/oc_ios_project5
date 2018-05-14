//
//  Constants.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

struct K {
  
  struct Pieces {
    static let count = 16
  }
  
  struct Font {
    struct Name {
      static let helveticaNeue = "Helvetica Neue"
      static let timeBurner = "TimeBurner"
    }
    
    struct size {
      static let choiceLabel: CGFloat = 17
      static let titleLabel: CGFloat = 1
      static let commentLabel: CGFloat = 1
      static let quitButtonLabel: CGFloat = 50
    }
    
    struct sizeRatio {
      static let commentLabel: CGFloat = 0.8
      static let titleLabel: CGFloat = 0.9
    }
  }
  
  struct ImageName {
    static let random = "Random"
    static let photos = "Photos"
    static let camera = "Camera"
  }
  
  struct String {
    static let title = "Gridy"
    static let comment = "Challenge yourself with a photo puzzle"
    static let choice = "- OR load your own -"
  }
  
  struct Layout {
    struct Height {
      static let button: CGFloat = 88
      static let buttonStackView: CGFloat = 200
      static let thinButton: CGFloat = 35
    }
    
    struct Width {
      static let button: CGFloat = 115
      static let thinButton: CGFloat = 100
    }
    
    struct Spacing {
      static let buttonStackViewiPad: CGFloat = 200
      static let buttonStackViewiPhone: CGFloat = 50
    }
    
    struct Padding {
      static let titleLabel: CGFloat = 16
    }
    
    struct HeightRatio {
      static let commentLabel: CGFloat = 0.2
      static let titleLabel: CGFloat = 0.25
    }
    
    struct cornerRadius {
      static let introButton: CGFloat = 10
    }
  }
}

//
//  Constants.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

struct Constant {
  
  struct View {
    struct Default {
      static let height: CGFloat = 44
      static let width: CGFloat = 44
    }
  }
  
  struct Tiles {
    struct Puzzle {
      static let countByRow = 4
      static let gapLength: CGFloat = 1
    }
    
    struct Container {
      static let countByRow = 6
      static let gapLength: CGFloat = 3.4
    }
  }
  
  struct Font {
    struct Name {
      static let helveticaNeue = "Helvetica Neue"
      static let timeBurner = "TimeBurner"
    }
    
    struct Size {
      static let choiceLabel: CGFloat = 15
      static let titleLabel: CGFloat = 1
      static let commentLabel: CGFloat = 1
      
      static let quitButtonLabel: CGFloat = 50
      static let startButtonLabel: CGFloat = 15
      static let instructionLabel: CGFloat = 15
      
      static let playViewLabels: CGFloat = 15
    }
    
    struct SizeRatio {
      static let commentLabel: CGFloat = 0.8
      static let titleLabel: CGFloat = 0.9
    }
  }
  
  struct ImageName {
    static let random = "Random"
    static let photos = "Photos"
    static let camera = "Camera"
    static let image = "Image"
    static let eye = "Eye"
  }
  
  struct String {
    static let title = "Gridy"
    static let comment = "Challenge yourself with a photo puzzle"
    static let choice = "- OR load your own -"
    static let instruction = "Drag pieces to the puzzle grid.\nSwipe out of the grid to undo"
    static let shareButtonTitle = "SHARE PUZZLE"
    static let newGameButtonTitle = "New Game"
    static let movesLabelText = "Moves:"
    static let scoresLabelText = "0"
  }
  
  struct Layout {
    struct Height {
      static let buttonStackView: CGFloat = 200
      static let informationLabel: CGFloat = 100
      static let shareButton: CGFloat = 30
      
      static let quitButton: CGFloat = 120
      static let startButton: CGFloat = 88
      static let button: CGFloat = 88
      static let instructionLabel: CGFloat = 88
    }
    
    struct Width {
      static let quitButton: CGFloat = 120
      static let startButton: CGFloat = 115
      static let button: CGFloat = 115
      static let instructionLabel: CGFloat = 115
    }
    
    struct Spacing {
      static let buttonStackViewiPad: CGFloat = 300
      static let buttonStackViewiPhone: CGFloat = 50
    }
    
    struct HeightRatio {
      static let commentLabel: CGFloat = 0.2
      static let titleLabel: CGFloat = 0.25
    }
    
    struct SizeRatio {
      static let puzzleGrid: CGFloat = 0.9
    }
    
    struct cornerRadius {
      static let introButton: CGFloat = 10
    }
  }
}

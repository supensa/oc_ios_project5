//
//  HeaderView.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/06/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
  func newGameButtonTapped()
}

class HeaderView: UIStackView {
  
  private var newGameButton: UIButton!
  private var gridyLabel: UILabel!
  private var movesLabel: UILabel!
  var scoreLabel: UILabel!
  
  weak var delegate: HeaderViewDelegate?
  
  required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  init() {
    super.init(frame: .zero)
    self.backgroundColor = UIColor.cyan
    self.axis = .horizontal
    self.distribution = .fillProportionally
    self.alignment = .fill
    
    initiliazeViews()
    addSubviews()
    newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
  }
  
  func initiliazeViews() {
    self.newGameButton = UIButton(type: .custom)
    newGameButton.layer.cornerRadius = 5
    newGameButton.clipsToBounds = true
    newGameButton.setTitle("New Game", for: .normal)
    newGameButton.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 12)
    newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
    newGameButton.setTitleColor(UIColor.white, for: .normal)
    newGameButton.backgroundColor = GridyColor.vistaBlue
    
    self.gridyLabel = UILabel()
    gridyLabel.text = "Gridy"
    gridyLabel.textColor = GridyColor.vistaBlue
    gridyLabel.font = UIFont(name: Constant.Font.Name.timeBurner, size: 15)
    gridyLabel.textAlignment = .center
    gridyLabel.adjustsFontSizeToFitWidth = true
    gridyLabel.backgroundColor = UIColor.white
    
    self.movesLabel = UILabel()
    movesLabel.text = "Moves:"
    movesLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    movesLabel.textAlignment = .center
    movesLabel.adjustsFontSizeToFitWidth = true
//    movesLabel.backgroundColor = UIColor.blue
    
    self.scoreLabel = UILabel()
    scoreLabel.text = "0"
    scoreLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    scoreLabel.textAlignment = .center
    scoreLabel.adjustsFontSizeToFitWidth = true
//    scoreLabel.backgroundColor = UIColor.green
  }
  
  func addSubviews() {
    self.addArrangedSubview(newGameButton)
    self.addArrangedSubview(gridyLabel)
    self.addArrangedSubview(movesLabel)
    self.addArrangedSubview(scoreLabel)
  }
  
  @objc func newGameButtonTapped() {
    delegate?.newGameButtonTapped()
  }
}

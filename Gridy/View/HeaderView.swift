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
  
  var newGameButton: UIButton!
  var gridyLabel: UILabel!
  var movesLabel: UILabel!
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
    newGameButton.setTitle(Constant.String.newGameButtonTitle, for: .normal)
    newGameButton.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 1)
    newGameButton.setTitleColor(UIColor.white, for: .normal)
    newGameButton.backgroundColor = UIColor.vistaBlue
    
    self.gridyLabel = UILabel()
    gridyLabel.text = Constant.String.title
    gridyLabel.textColor = UIColor.vistaBlue
    gridyLabel.font = UIFont(name: Constant.Font.Name.timeBurner, size: 1)
    gridyLabel.textAlignment = .center
    gridyLabel.backgroundColor = UIColor.white
    
    self.movesLabel = UILabel()
    movesLabel.text = Constant.String.movesLabelText
    movesLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 1)
    movesLabel.textAlignment = .center
    
    self.scoreLabel = UILabel()
    scoreLabel.text = Constant.String.scoresLabelText
    scoreLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 1)
    scoreLabel.textAlignment = .center
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

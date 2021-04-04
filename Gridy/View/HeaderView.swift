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
    
    self.axis = .horizontal
    self.distribution = .fillProportionally
    self.alignment = .fill
    
    initiliazeViews()
    addSubviews()
    
    newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
  }
  
  @objc private func newGameButtonTapped() {
    delegate?.newGameButtonTapped()
  }
  
  func setNormalFontSize() {
    newGameButton.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    gridyLabel.font = UIFont(name: Constant.Font.Name.timeBurner, size: 30)
    movesLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    scoreLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
  }
  
  func setBigFontSize() {
    newGameButton.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 30)
    gridyLabel.font = UIFont(name: Constant.Font.Name.timeBurner, size: 60)
    movesLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 30)
    scoreLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 30)
  }
  
  private func initiliazeViews() {
    self.newGameButton = UIButton(type: .custom)
    newGameButton.layer.cornerRadius = 5
    newGameButton.clipsToBounds = true
    newGameButton.setTitle(Constant.String.newGameButtonTitle, for: .normal)
    newGameButton.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    newGameButton.setTitleColor(UIColor.white, for: .normal)
    newGameButton.backgroundColor = UIColor.vistaBlue
    
    self.gridyLabel = UILabel()
    gridyLabel.text = Constant.String.title
    gridyLabel.textColor = UIColor.vistaBlue
    gridyLabel.font = UIFont(name: Constant.Font.Name.timeBurner, size: 30)
    gridyLabel.textAlignment = .center
    gridyLabel.backgroundColor = UIColor.white
    
    self.movesLabel = UILabel()
    movesLabel.text = Constant.String.movesLabelText
    movesLabel.textColor = UIColor.vistaBlue
    movesLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    movesLabel.textAlignment = .center
    
    self.scoreLabel = UILabel()
    scoreLabel.text = Constant.String.scoresLabelText
    scoreLabel.textColor = UIColor.vistaBlue
    scoreLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    scoreLabel.textAlignment = .center
  }
  
  private func addSubviews() {
    self.addArrangedSubview(newGameButton)
    self.addArrangedSubview(gridyLabel)
    self.addArrangedSubview(movesLabel)
    self.addArrangedSubview(scoreLabel)
  }
}

//
//  PlayView.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol PlayViewDelegate {
  func startNewGame()
}

class PlayView: UIView {
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  override init(frame: CGRect) { super.init(frame: frame) }
  
  private var image:UIImage?
  private var imageView: UIImageView!
  private var newGameButton: UIButton!
  
  var delegate: PlayViewDelegate!
  
  convenience init(image: UIImage?) {
    self.init(frame: CGRect())
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white
    if let image = image {
      self.image = image
    }
    
    instantiateSubviews()
    layOutSubviews()
    detectUserActions()
  }
  
  func setupIn(parentView: UIView) {
    parentView.backgroundColor = UIColor.white
    parentView.addSubview(self)
    let safeArea = parentView.safeAreaLayoutGuide
    self.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    self.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
    self.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
  }
  
  private func instantiateSubviews() {
    imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    
    newGameButton = UIButton(type: .custom)
    newGameButton.translatesAutoresizingMaskIntoConstraints = false
    newGameButton.layer.cornerRadius = 10
    newGameButton.clipsToBounds = true
    newGameButton.setTitle("New Game", for: .normal)
    newGameButton.titleLabel?.font = UIFont(name: K.Font.Name.helveticaNeue, size: K.Font.size.choiceLabel)
    newGameButton.setTitleColor(UIColor.white, for: .normal)
    newGameButton.backgroundColor = GridyColor.vistaBlue
  }
  
  private func layOutSubviews() {
    addSubview(imageView)
    imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    
    addSubview(newGameButton)
    newGameButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    newGameButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100).isActive = true
    newGameButton.heightAnchor.constraint(equalToConstant: K.Layout.Height.thinButton).isActive = true
    newGameButton.widthAnchor.constraint(equalToConstant: K.Layout.Width.thinButton).isActive = true
  }
  
  private func detectUserActions() {
    newGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
  }
  
  @objc private func startNewGame() {
    delegate.startNewGame()
  }
}

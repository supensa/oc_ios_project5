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
//  override init(frame: CGRect) { super.init(frame: frame) }
  
  private var images: [UIImage]!
  private var imageViews: [ImageView]!
  private var newGameButton: UIButton!
  
  private var imageView: ImageView!
  
  var delegate: PlayViewDelegate!
  
  init(images: [UIImage]) {
    super.init(frame: CGRect())
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white
    self.images = images
    
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
    instantiateImageViews()
    
    imageView = ImageView.init(image: images![1])
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = GridyColor.janna.cgColor
    
    instantiateNewGameButton()
  }
  
  private func instantiateNewGameButton() {
    newGameButton = UIButton(type: .custom)
    newGameButton.translatesAutoresizingMaskIntoConstraints = false
    newGameButton.layer.cornerRadius = 10
    newGameButton.clipsToBounds = true
    newGameButton.setTitle("New Game", for: .normal)
    newGameButton.titleLabel?.font = UIFont(name: K.Font.Name.helveticaNeue, size: K.Font.size.choiceLabel)
    newGameButton.setTitleColor(UIColor.white, for: .normal)
    newGameButton.backgroundColor = GridyColor.vistaBlue
  }
  
  private func instantiateImageViews() {
    self.imageViews = [ImageView]()
    for image in images {
      let imageView = ImageView(image: image)
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFit
      imageView.layer.borderWidth = 1
      imageView.layer.borderColor = GridyColor.janna.cgColor
      self.imageViews.append(imageView)
    }
  }
  
  private func layOutSubviews() {
    let safeArea = self.safeAreaLayoutGuide
    addSubview(imageView)
    imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    
    layOutNewGameButton(safeArea: safeArea)
    layOutBigImageViews()
  }
  
  private func layOutNewGameButton(safeArea: UILayoutGuide) {
    addSubview(newGameButton)
    newGameButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
    newGameButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16).isActive = true
    newGameButton.heightAnchor.constraint(equalToConstant: K.Layout.Height.thinButton).isActive = true
    newGameButton.widthAnchor.constraint(equalToConstant: K.Layout.Width.thinButton).isActive = true
  }
  
  private func layOutBigImageViews() {
    imageViews = Array<ImageView>()
    let max = images.count - 1
    for index in 0...max {
      let position = max - index
      imageViews.append(ImageView.init(position: position))
    }
  }
  
  private func detectUserActions() {
    newGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
  }
  
  @objc private func startNewGame() {
    delegate.startNewGame()
  }
}

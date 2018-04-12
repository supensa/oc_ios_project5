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
  
  private var images: [Image]!
  private var imageViews: [ImageView]!
  private var bigViews: [View]!
  private var smallViews: [View]!
  private var newGameButton: UIButton!
  
  var delegate: PlayViewDelegate!
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(images: [Image]) {
    super.init(frame: UIScreen.main.bounds)
    self.isUserInteractionEnabled = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white
    self.images = images
    
    instantiateSubviews()
    layOutSubviews()
    detectUserActions()
  }
  
  func setupIn(parentView view: UIView) {
    view.backgroundColor = UIColor.white
    view.addSubview(self)
    let safeArea = view.safeAreaLayoutGuide
    self.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    self.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
    self.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
  }
  
  private func instantiateSubviews() {
    instantiateNewGameButton()
    // order matters
    instantiateContainerViews()
    instantiateImageViews()
  }
  
  private func layOutSubviews() {
    let safeArea = self.safeAreaLayoutGuide
    layOutNewGameButton(safeArea: safeArea)
  }
  
  private func detectUserActions() {
    newGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
    setupGestureRecognizers()
  }
  
  func setupGestureRecognizers() {
    for imageView in imageViews {
      let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(moveImageView))
      panGestureRecognizer.delegate = self
      imageView.addGestureRecognizer(panGestureRecognizer)
    }
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
  
  private func instantiateContainerViews() {
    self.smallViews = [View]()
    self.bigViews = [View]()
    let max = images.count - 1
    for index in 0...max {
      var view = View()
      view.translatesAutoresizingMaskIntoConstraints = true
      view.backgroundColor = UIColor.lightGray
      self.smallViews.append(view)
      addSubview(self.smallViews[index])
      view = View.init(position: index)
      view.translatesAutoresizingMaskIntoConstraints = true
      view.backgroundColor = UIColor.lightGray
      self.bigViews.append(view)
      addSubview(self.bigViews[index])
    }
  }
  
  private func instantiateImageViews() {
    self.imageViews = [ImageView]()
    let max = images.count - 1
    for index in 0...max {
      let imageView = ImageView.init(defaultImage: images[index])
      imageView.set(ContainerView: self.smallViews[index])
      self.imageViews.append(imageView)
      addSubview(self.imageViews[index])
    }
  }
  
  private func layOutNewGameButton(safeArea: UILayoutGuide) {
    addSubview(newGameButton)
    newGameButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
    newGameButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16).isActive = true
    newGameButton.heightAnchor.constraint(equalToConstant: K.Layout.Height.thinButton).isActive = true
    newGameButton.widthAnchor.constraint(equalToConstant: K.Layout.Width.thinButton).isActive = true
  }
  
  private func layOutSmallContainerViews() {
    let margin = Position.init(parentView: self, isEditingView: false).margin
    layOutContainerViews(views: smallViews, forSmallSquares: true, margin: margin)
  }
  
  private func layOutBigContainerViews() {
    layOutContainerViews(views: bigViews, forSmallSquares: false, margin: 0)
  }
  
  private func layOutContainerViews(views: [UIView], forSmallSquares: Bool, margin: CGFloat) {
    let margin = margin
    let position = Position.init(parentView: self, isEditingView: false, forSmallSquares: forSmallSquares, margin: margin)
    let rectangles = position.getContainerSquares()
    
    let max = rectangles.count - 1
    for index in 0...max {
      let view = views[index]
      view.frame = rectangles[index]
      view.layer.borderWidth = 1
      view.layer.borderColor = GridyColor.janna.cgColor
    }
  }
  
  func layOutImageViews() {
    let max = smallViews.count - 1
    for index in 0...max {
      self.imageViews[index].position()
    }
  }
  
  @objc private func moveImageView(_ sender: UIPanGestureRecognizer) {
    if let view = sender.view {
      bringSubview(toFront: view)
      let translation = sender.translation(in: self)
      let newPoint = CGPoint(x: view.center.x + translation.x,
                             y: view.center.y + translation.y)
      view.center = newPoint
      sender.setTranslation(CGPoint.zero, in: self)
      
      if sender.state == UIGestureRecognizerState.ended {
        self.positionImageView(view: view as! ImageView)
      }
    }
  }

  @objc private func startNewGame() {
    delegate.startNewGame()
  }
  
  private func positionImageView(view: ImageView) {
    var isOutBigViews = true
    for bigView in bigViews {
      if bigView.frame.contains(view.center) {
        isOutBigViews = false
        if view.change(ContainerView: bigView) {
          // TODO: Notify controller it is a different container view
        }
      }
    }
    if isOutBigViews {
      if view.resetFrame() {
        // TODO: Notify controller it is a different container view
      }
    }
  }
}

extension PlayView: UIGestureRecognizerDelegate {
  // Delegate method: UITraitEnvironment
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    layOutSmallContainerViews()
    layOutBigContainerViews()
    layOutImageViews()
  }
}

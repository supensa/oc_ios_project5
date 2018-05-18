//
//  PlayViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
  var images: [Image]!
  private var imageViews: [ImageView]!
  private var smallGridView: GridView!
  private var bigGridView: GridView!
  private var newGameButton: UIButton!
  private var instructionsLabel: UILabel!
  private var isLandscape: Bool!
  
  private var landscapeConstraints: [NSLayoutConstraint]!
  private var portraitConstraints: [NSLayoutConstraint]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.isUserInteractionEnabled = true
    self.view.backgroundColor = UIColor.white
    
    self.isLandscape = self.view.bounds.width > self.view.bounds.height
    
    instantiateSubviews()
    addSubviews()
    detectUserActions()
    
    self.portraitConstraints = [NSLayoutConstraint]()
    self.landscapeConstraints = [NSLayoutConstraint]()
    
    setNewGameButtonConstraints()
    setBigGridViewConstraints()
    setSmallGridViewConstraints()
    setInstructionLabelConstraints()
    activateConstraints()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    isLandscape = size.width > size.height
    activateConstraints()
  }
  
  private func instantiateSubviews() {
    instantiateNewGameButton()
    instantiateImageViews()
    instantiateGridViews()
    instantiateLabels()
  }
  
  private func instantiateNewGameButton() {
    newGameButton = UIButton(type: .custom)
    newGameButton.layer.cornerRadius = 10
    newGameButton.clipsToBounds = true
    newGameButton.setTitle("New Game", for: .normal)
    newGameButton.titleLabel?.font = UIFont(name: K.Font.Name.helveticaNeue, size: K.Font.size.choiceLabel)
    newGameButton.setTitleColor(UIColor.white, for: .normal)
    newGameButton.backgroundColor = GridyColor.vistaBlue
  }
  
  private func instantiateImageViews() {
    self.imageViews = [ImageView]()
    let max = images.count - 1
    for index in 0...max {
      images[index].actualPosition = index
      let imageView = ImageView.init(image: images[index].image)
      imageView.translatesAutoresizingMaskIntoConstraints = true
      self.imageViews.append(imageView)
    }
  }
  
  private func instantiateGridViews() {
    smallGridView = GridView(tag: 0)
    smallGridView.datasource = self
    smallGridView.delegate = self
    smallGridView.backgroundColor = UIColor.red
    bigGridView = GridView(tag: 1)
    bigGridView.datasource = self
    bigGridView.delegate = self
    bigGridView.backgroundColor = GridyColor.pixieGreen
  }
  
  private func instantiateLabels() {
    self.instructionsLabel = UILabel()
    instructionsLabel.text = "Drag pieces to the grid.\nswipe out of the grid to undo"
    instructionsLabel.numberOfLines = 0
    instructionsLabel.font = UIFont(name: K.Font.Name.timeBurner, size: 15)
    instructionsLabel.textAlignment = .center
    instructionsLabel.adjustsFontSizeToFitWidth = true
    instructionsLabel.backgroundColor = UIColor.cyan
  }
  
  private func addSubviews() {
    self.view.addSubview(newGameButton)
    self.view.addSubview(bigGridView)
    self.view.addSubview(smallGridView)
    self.view.addSubview(instructionsLabel)
//    self.view.addSubview(smallGridView)
//    for imageView in imageViews {
//      self.view.addSubview(imageView)
//    }
  }
  
  private func setNewGameButtonConstraints() {
    newGameButton.translatesAutoresizingMaskIntoConstraints = false
    
    let height = K.Layout.Height.thinButton
    let width = K.Layout.Width.thinButton
    newGameButton.heightAnchor.constraint(equalToConstant: height).isActive = true
    newGameButton.widthAnchor.constraint(equalToConstant: width).isActive = true
    
    let margin = view.layoutMarginsGuide
    self.landscapeConstraints.append(newGameButton.topAnchor.constraint(equalTo: margin.topAnchor, constant: 8))
    self.landscapeConstraints.append(newGameButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: -8))
    self.portraitConstraints.append(newGameButton.topAnchor.constraint(equalTo: margin.topAnchor, constant: 0))
    self.portraitConstraints.append(newGameButton.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 0))
  }
  
  private func setBigGridViewConstraints() {
    bigGridView.translatesAutoresizingMaskIntoConstraints = false
    setBigGridViewConstraintsInLandscape()
    setBigGridViewConstraintsInPortrait()
  }
  
  private func setBigGridViewConstraintsInPortrait() {
    let margin = view.layoutMarginsGuide
    self.portraitConstraints.append(bigGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: 0))
    self.portraitConstraints.append(bigGridView.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 0))
    self.portraitConstraints.append(bigGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: 0))
    self.portraitConstraints.append(bigGridView.heightAnchor.constraint(equalTo: bigGridView.widthAnchor))
  }
  
  private func setBigGridViewConstraintsInLandscape() {
    let margin = view.layoutMarginsGuide
    self.landscapeConstraints.append(bigGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: 0))
    self.landscapeConstraints.append(bigGridView.topAnchor.constraint(equalTo: margin.topAnchor, constant: 0))
    self.landscapeConstraints.append(bigGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: 0))
    self.landscapeConstraints.append(bigGridView.widthAnchor.constraint(equalTo: bigGridView.heightAnchor))
  }
  
  private func setSmallGridViewConstraints() {
    smallGridView.translatesAutoresizingMaskIntoConstraints = false
    smallGridView.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 3).isActive = true
    smallGridView.leftAnchor.constraint(equalTo: newGameButton.leftAnchor, constant: -5).isActive = true
    self.setSmallGridViewConstraintsInPortrait()
    self.setSmallGridViewConstraintsInLandscape()
  }
  
  private func setSmallGridViewConstraintsInPortrait() {
    let height = smallGridViewHeightInPortrait()
    
    let margin = view.layoutMarginsGuide
    self.portraitConstraints.append(smallGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: 5))
    self.portraitConstraints.append(smallGridView.heightAnchor.constraint(equalToConstant: height))
  }
  
  private func smallGridViewHeightInPortrait() -> CGFloat {
    var tileWidth: CGFloat = 0
    if isLandscape {
      tileWidth = self.view.bounds.height - view.layoutMargins.top - view.layoutMargins.left + 10
    } else {
      tileWidth = self.view.bounds.width - view.layoutMargins.left - view.layoutMargins.right + 10
    }
    tileWidth = (tileWidth - 5 * 7) / 6
    let numberOfRow = (CGFloat(images.count) / CGFloat(6)).rounded(.up)
    return tileWidth * numberOfRow
  }

  private func setSmallGridViewConstraintsInLandscape() {
    let height = smallGridViewHeightInLandscape()
    self.landscapeConstraints.append(smallGridView.rightAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: -10))
    self.landscapeConstraints.append(smallGridView.heightAnchor.constraint(equalToConstant: height))
  }
  
  private func smallGridViewHeightInLandscape() -> CGFloat {
    var tileWidth: CGFloat = 0
    if isLandscape {
      tileWidth = self.view.bounds.width - view.layoutMargins.left - self.view.bounds.height + 21
    } else {
      tileWidth = self.view.bounds.height - view.layoutMargins.top - view.layoutMargins.left - self.view.bounds.width + 21
    }
    tileWidth = (tileWidth - 5 * 7) / 6
    let numberOfRow = (CGFloat(images.count) / CGFloat(6)).rounded(.up)
    return tileWidth * numberOfRow
  }
  
  private func setInstructionLabelConstraints() {
    instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
    
    instructionsLabel.leftAnchor.constraint(equalTo: smallGridView.leftAnchor, constant: 0).isActive = true
    
    self.setInstructionLabelConstraintsInPortrait()
    self.setBigGridViewConstraintsInLandscape()
  }
  
  func setInstructionLabelConstraintsInPortrait() {
    self.portraitConstraints.append(instructionsLabel.topAnchor.constraint(equalTo: smallGridView.bottomAnchor, constant: 0))
    self.portraitConstraints.append(instructionsLabel.rightAnchor.constraint(equalTo: smallGridView.rightAnchor, constant: 0))
    self.portraitConstraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: bigGridView.topAnchor, constant: 0))
  }
  
  func setInstructionLabelConstraintsInLandscape() {
    self.landscapeConstraints.append(instructionsLabel.topAnchor.constraint(equalTo: smallGridView.bottomAnchor, constant: 10))
    self.landscapeConstraints.append(instructionsLabel.rightAnchor.constraint(equalTo: smallGridView.rightAnchor, constant: 0))
    self.landscapeConstraints.append(instructionsLabel.heightAnchor.constraint(equalToConstant: 15))
  }
  
  func activateConstraints() {
    if isLandscape {
      NSLayoutConstraint.deactivate(self.portraitConstraints)
      NSLayoutConstraint.activate(self.landscapeConstraints)
    } else {
      NSLayoutConstraint.deactivate(self.landscapeConstraints)
      NSLayoutConstraint.activate(self.portraitConstraints)
    }
  }
  
///------------------------------------------------------------------------------------------------------------------------------------------
  private func detectUserActions() {
    newGameButton.addTarget(self, action: #selector(tappedNewGameButton), for: .touchUpInside)
    setupGestureRecognizers()
  }
  
  private func setupGestureRecognizers() {
    for imageView in imageViews {
      let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(moveImageView))
      imageView.addGestureRecognizer(panGestureRecognizer)
    }
  }
  
  @objc private func moveImageView(_ sender: UIPanGestureRecognizer) {
    if let view = sender.view {
      self.view.bringSubview(toFront: view)
      let translation = sender.translation(in: self.view)
      let newPoint = CGPoint(x: view.center.x + translation.x,
                             y: view.center.y + translation.y)
      view.center = newPoint
      sender.setTranslation(CGPoint.zero, in: self.view)
      
      if sender.state == UIGestureRecognizerState.ended {
        if bigGridView.frame.contains(view.center) {
          let max = bigGridView.subviews.count - 1
          for index in 0...max {
            let tile = bigGridView.subviews[index]
            let center = convertCoordinates(of: view.center, into: bigGridView)
            if tile.frame.contains(center) {
              let frame = convertFrame(of: tile, in: bigGridView)
              view.frame = frame
            }
          }
        } else {
          // TODO: Put frame in smallGridview
        }
      }
    }
  }
  
  @objc private func tappedNewGameButton() {
    dismiss(animated: true, completion: nil)
  }
  
///------------------------------------------------------------------------------------------------------------------------------------------
  private func convertFrame(of tile: UIView, in view: UIView) -> CGRect {
    let width = tile.frame.width
    let height = tile.frame.height
    let origin = convertCoordinates(of: tile.frame.origin, from: view)
    let size = CGSize(width: width, height: height)
    return CGRect(origin: origin, size: size)
  }
  
  private func convertCoordinates(of point: CGPoint, from view: UIView) -> CGPoint {
    let x = point.x + view.frame.origin.x
    let y = point.y + view.frame.origin.y
    return CGPoint(x: x, y: y)
  }
  
  private func convertCoordinates(of point: CGPoint, into view: UIView) -> CGPoint {
    let x = point.x - view.frame.origin.x
    let y = point.y - view.frame.origin.y
    return CGPoint(x: x, y: y)
  }
}

extension PlayViewController: GridViewDelegate {
  func gapLength(gridView tag: Int) -> CGFloat {
    if tag == 0 { return 5 }
    return 1
  }
}

extension PlayViewController: GridViewDataSource {
  func getTile(at index: Int) -> UIView {
    // To Implement
    let tile = UIView()
    tile.backgroundColor = UIColor.lightGray
    return tile
  }
  
  func numberOfTiles(gridView tag: Int) -> Int {
    return images.count
  }
  
  func numberOfTilesPerRow(gridView tag: Int) -> Int {
    if tag == 0 { return 6 }
    return 4
  }
}

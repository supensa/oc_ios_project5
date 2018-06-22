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
  var hintImage: UIImage!
  private var imageViews: [ImageView]!
  private var smallGridView: GridView!
  private var bigGridView: GridView!
  
  private var header: HeaderView!
  private var hintView: HintView!
  private var isLandscape: Bool!
  
  private var instructionsLabel: UILabel!
  
  private var bigGridModel: BigGrid!
  private var smallGridModel: SmallGrid!
  private var score = 0
  
  private var landscapeConstraints: [NSLayoutConstraint]!
  private var portraitConstraints: [NSLayoutConstraint]!
  
  private var smallGridViewRightAnchor: NSLayoutConstraint!
  private var smallGridViewHeightAnchor: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bigGridModel = BigGrid(numberOftile: images.count)
    self.smallGridModel = SmallGrid(numberOftile: images.count)
    
    self.portraitConstraints = [NSLayoutConstraint]()
    self.landscapeConstraints = [NSLayoutConstraint]()
    
    self.view.isUserInteractionEnabled = true
    self.view.backgroundColor = UIColor.white
    
    self.isLandscape = self.view.bounds.width > self.view.bounds.height
    
    instantiateSubviews()
    addSubviews()
    setConstraints()
    detectUserActions()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    self.isLandscape = self.view.frame.width > self.view.frame.height
    
    activateConstraints()
    
    if isLandscape {
      updateSmallGridViewConstraintsInLandscape()
    } else {
      updateSmallGridViewConstraintsInPortrait()
    }
  }
  
  override func viewDidLayoutSubviews() {
     refreshLayout()
  }
  
  private func instantiateSubviews() {
    instantiateViews()
    instantiateImageViews()
    instantiateGridViews()
  }
  
  private func addSubviews() {
    self.view.addSubview(header)
    self.view.addSubview(bigGridView)
    self.view.addSubview(smallGridView)
    self.view.addSubview(instructionsLabel)
    
    for imageView in imageViews {
      self.view.addSubview(imageView)
    }
    
    self.view.addSubview(hintView)
  }
  
  private func setConstraints() {
    setBigGridViewConstraints()
    setSmallGridViewConstraints()
    setViewsConstraints()
    
    for constraint in portraitConstraints {
      constraint.priority = .init(750)
    }
    
    for constraint in landscapeConstraints {
      constraint.priority = .init(750)
    }
  }
  
  private func instantiateGridViews() {
    smallGridView = GridView(tag: 0, eyeOption: true)
    smallGridView.datasource = self
    smallGridView.delegate = self
    smallGridView.backgroundColor = UIColor.red
    bigGridView = GridView(tag: 1)
    bigGridView.datasource = self
    bigGridView.delegate = self
    bigGridView.backgroundColor = GridyColor.pixieGreen
    
    smallGridView.translatesAutoresizingMaskIntoConstraints = false
    bigGridView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func instantiateViews() {
    self.instructionsLabel = UILabel()
    instructionsLabel.text = "Drag pieces to the grid.\nSwipe out of the grid to undo"
    instructionsLabel.numberOfLines = 0
    instructionsLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    instructionsLabel.textAlignment = .center
    instructionsLabel.adjustsFontSizeToFitWidth = true
    
    self.header = HeaderView()
    header.delegate = self
    
    self.hintView = HintView(image: self.hintImage)
    hintView.isUserInteractionEnabled = false
    hintView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    hintView.imageView.alpha = 0
    
    header.translatesAutoresizingMaskIntoConstraints = false
    instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
    hintView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func instantiateImageViews() {
    self.imageViews = Array(repeating: ImageView(), count: images.count)
    var index = Array(0...imageViews.count-1)
    for image in images {
      if let randomIndex = index.randomPop() {
        let imageView = ImageView.init(image: image.image)
        imageView.tag = image.id
        imageView.translatesAutoresizingMaskIntoConstraints = true
        self.imageViews[image.id] = imageView
        smallGridModel.updatePosition(id: image.id, position: randomIndex)
      }
    }
  }
  
  private func refreshLayout() {
    smallGridView.layoutIfNeeded()
    bigGridView.layoutIfNeeded()
    for imageView in imageViews {
      let idImage = imageView.tag
      if let position = bigGridModel.getPosition(id: idImage) {
        let tile = bigGridView.subviews[position]
        let frame = convertFrame(of: tile, in: bigGridView)
        imageView.frame = frame
      } else if let position = smallGridModel.getPosition(id: idImage) {
        let tile = smallGridView.subviews[position]
        let frame = convertFrame(of: tile, in: smallGridView)
        imageView.frame = frame
      }
    }
    self.header.scoreLabel.text = "\(score)"
  }
  
  private func setBigGridViewConstraints() {
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
    smallGridView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
    smallGridView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 0).isActive = true
  }
  
  private func updateSmallGridViewConstraintsInPortrait() {
    let height = smallGridViewHeightInPortrait()
    
    if smallGridViewHeightAnchor != nil && smallGridViewRightAnchor != nil {
      smallGridViewRightAnchor.isActive = false
      smallGridViewHeightAnchor.isActive = false
    }
    
    let margin = view.layoutMarginsGuide
    self.smallGridViewRightAnchor = smallGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: 0)
    self.smallGridViewHeightAnchor = smallGridView.heightAnchor.constraint(equalToConstant: height)
    
    smallGridViewRightAnchor.isActive = true
    smallGridViewHeightAnchor.isActive = true
  }
  
  private func updateSmallGridViewConstraintsInLandscape() {
    let height = smallGridViewHeightInLandscape()
    
    if smallGridViewHeightAnchor != nil && smallGridViewRightAnchor != nil {
      smallGridViewRightAnchor.isActive = false
      smallGridViewHeightAnchor.isActive = false
    }
    
    self.smallGridViewRightAnchor = smallGridView.rightAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0)
    self.smallGridViewHeightAnchor = smallGridView.heightAnchor.constraint(equalToConstant: height)
    
    smallGridViewRightAnchor.isActive = true
    smallGridViewHeightAnchor.isActive = true
  }
  
  func tileWidthInPortrait() -> CGFloat {
    let width: CGFloat = self.view.bounds.width - view.layoutMargins.left - view.layoutMargins.right
    let tileWidth = (width - 5 * 7) / 6
    return tileWidth
  }
  
  func tileWidthInLandscape() -> CGFloat {
    let width: CGFloat = self.view.bounds.width - view.layoutMargins.left - view.layoutMargins.right - self.view.bounds.height
    let tileWidth = (width - 5 * 7) / 6
    return tileWidth
  }
  
  private func smallGridViewHeightInPortrait() -> CGFloat {
    let tileWidth = self.tileWidthInPortrait()
    let numberOfRow = (CGFloat(images.count) / CGFloat(6)).rounded(.up)
    return tileWidth * numberOfRow + 4 * 5
  }
  
  private func smallGridViewHeightInLandscape() -> CGFloat {
    let tileWidth = self.tileWidthInLandscape()
    let numberOfRow = (CGFloat(images.count) / CGFloat(6)).rounded(.up)
    return tileWidth * numberOfRow + 4 * 5
  }
  
  private func setViewsConstraints() {
    instructionsLabel.leftAnchor.constraint(equalTo: smallGridView.leftAnchor, constant: 0).isActive = true
    instructionsLabel.topAnchor.constraint(equalTo: smallGridView.bottomAnchor, constant: 0).isActive = true
    instructionsLabel.rightAnchor.constraint(equalTo: smallGridView.rightAnchor, constant: 0).isActive = true
    
    self.setInstructionLabelConstraintsInPortrait()
    self.setInstructionLabelConstraintsInLandscape()
    
    let margin = view.layoutMarginsGuide
    header.topAnchor.constraint(equalTo: margin.topAnchor, constant: 0).isActive = true
    header.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 0).isActive = true
    header.rightAnchor.constraint(equalTo: smallGridView.rightAnchor, constant: 0).isActive = true
    header.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    hintView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    hintView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    hintView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    hintView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
  }
  
  func setInstructionLabelConstraintsInPortrait() {
    self.portraitConstraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: bigGridView.topAnchor, constant: 0))
  }
  
  func setInstructionLabelConstraintsInLandscape() {
    self.landscapeConstraints.append(instructionsLabel.heightAnchor.constraint(equalToConstant: 35))
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
    setupGestureRecognizers()
  }
  
  private func setupGestureRecognizers() {
    var tag = 0
    for imageView in imageViews {
      imageView.tag = tag
      tag += 1
      let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(moveImageView))
      imageView.addGestureRecognizer(panGestureRecognizer)
    }
  }
  
  @objc private func moveImageView(_ sender: UIPanGestureRecognizer) {
    if let view = sender.view {
      let tag = view.tag
      self.view.bringSubview(toFront: view)
      let translation = sender.translation(in: self.view)
      let newPoint = CGPoint(x: view.center.x + translation.x,
                             y: view.center.y + translation.y)
      view.center = newPoint
      sender.setTranslation(CGPoint.zero, in: self.view)
      
      if sender.state == UIGestureRecognizerState.ended {
        print(tag)
        if bigGridView.frame.contains(view.center) {
          let max = bigGridView.subviews.count - 1
          for index in 0...max {
            let tile = bigGridView.subviews[index]
            let center = convertCoordinates(of: view.center, into: bigGridView)
            if tile.frame.contains(center) {
              if bigGridModel.isTileFree(at: index) && index != bigGridModel.getPosition(id: tag) {
                smallGridModel.updatePosition(id: tag, position: nil)
                bigGridModel.updatePosition(id: tag, position: index)
                self.score += 1
                break
              }
              break
            }
          }
        } else {
          smallGridModel.updatePosition(id: tag, position: nil)
          if let _ = bigGridModel.getPosition(id: tag) { self.score += 1 }
          bigGridModel.updatePosition(id: tag, position: nil)
          let position = smallGridModel.getFreeTilePosition()
          smallGridModel.updatePosition(id: tag, position: position)
        }
        
        refreshLayout()
        
        if bigGridModel.isFull() {
          print("It is full")
          if bigGridModel.match() {
            print("End of Game")
            self.instructionsLabel.text = "GAME OVER"
            self.instructionsLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 35)
            self.instructionsLabel.textColor = UIColor.red
            for imageView in imageViews {
              imageView.isUserInteractionEnabled = false
            }
          }
        }
      }
    }
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
  func eyeImageViewTapped() {
    view.bringSubview(toFront: hintView)
    hintView.appearsTemporarily()
  }
  
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

extension PlayViewController: HeaderViewDelegate {
  func newGameButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
}
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
  
  private var instructionsLabel: UILabel!
  
  private var bigGridModel: GridModel!
  private var smallGridModel: GridModel!
  private var score = 0
  
  private var constraints: [NSLayoutConstraint]!
  private var commonConstraints: [NSLayoutConstraint]!
  
  private var smallGridViewRightAnchor: NSLayoutConstraint!
  private var smallGridViewHeightAnchor: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bigGridModel = GridModel(numberOftile: images.count)
    self.smallGridModel = GridModel(numberOftile: images.count)
    
    self.constraints = [NSLayoutConstraint]()
    self.commonConstraints = [NSLayoutConstraint]()
    
    self.view.isUserInteractionEnabled = true
    self.view.backgroundColor = UIColor.white
    
    instantiateSubviews()
    addSubviews()
    detectUserActions()
    setupHintViewConstraints()
    setupCommonConstraintsPriority()
    NSLayoutConstraint.activate(self.commonConstraints)
  }
  
  // Be careful: Infinite Layout loop might occur
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    if traitCollection.horizontalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular {
      let isLandscape = self.view.bounds.width >= self.view.bounds.height
      self.clearAllConstraints()
      if isLandscape {
        // Landscape constraints for IPad
        setupConstraintsInLandscapeEnvironment(padding: 90)
      } else {
        // Portrait constraints for IPad
        setupConstraintsInPortraitEnvironment(padding: 60)
      }
      setupConstraintsPriority()
      NSLayoutConstraint.activate(self.constraints)
    }
  }
  
  override func viewDidLayoutSubviews() {
    refreshLayout()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let horizontaSizeClassChanged = previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
    let verticalSizeClassChanged = previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass
    
    if verticalSizeClassChanged || horizontaSizeClassChanged {
      self.clearAllConstraints()
      
      let sizeClass = (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass)
      
      switch sizeClass {
      case (.regular, .regular):
        fallthrough
      case (.compact, .regular):
        setupConstraintsInPortraitEnvironment(padding: 0)
      case (.compact, .compact), (.regular,.compact):
        setupConstraintsInLandscapeEnvironment(padding: 46)
      default: break
      }
      setupConstraintsPriority()
      NSLayoutConstraint.activate(self.constraints)
    }
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
  
  private func setupConstraintsInPortraitEnvironment(padding: CGFloat) {
    setupBigGridViewConstraintsInPortraitEnvironmen(padding: padding)
    setupOtherViewsConstraintsInPortraitEnvironment()
    setupSmallGridViewConstraintsInPortraitEnvironment(padding: padding)
  }
  
  private func setupConstraintsInLandscapeEnvironment(padding: CGFloat) {
    setupBigGridViewConstraintInLandscapeEnvironment(padding: padding)
    setupSmallGridViewConstraintsInLandscapeEnvironment(padding: padding)
    setupOtherViewsConstraintsInLandscapeEnvironment()
  }
  
  private func setupConstraintsPriority() {
    for constraint in constraints {
      constraint.priority = .init(750)
    }
  }
  
  func setupCommonConstraintsPriority() {
    for constraint in commonConstraints {
      constraint.priority = .init(751)
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
      if let position = bigGridModel.position(id: idImage) {
        let tile = bigGridView.subviews[position]
        let frame = convertFrame(of: tile, in: bigGridView)
        imageView.frame = frame
      } else if let position = smallGridModel.position(id: idImage) {
        let tile = smallGridView.subviews[position]
        let frame = convertFrame(of: tile, in: smallGridView)
        imageView.frame = frame
      }
    }
    self.header.scoreLabel.text = "\(score)"
    let smallSize = smallGridView.subviews[0].frame.size
    let bigSize = bigGridView.subviews[0].frame.size
    print("Small Tile size: \(smallSize)")
    print("Big Tile size: \(bigSize)")
  }
  
  
  private func setupHintViewConstraints() {
    let margin = view.layoutMarginsGuide
    self.commonConstraints.append(hintView.topAnchor.constraint(equalTo: margin.topAnchor))
    self.commonConstraints.append(hintView.bottomAnchor.constraint(equalTo: margin.bottomAnchor))
    self.commonConstraints.append(hintView.leftAnchor.constraint(equalTo: margin.leftAnchor))
    self.commonConstraints.append(hintView.rightAnchor.constraint(equalTo: margin.rightAnchor))
  }
  
  private func setupOtherViewsConstraintsInPortraitEnvironment() {
    let margin = view.layoutMarginsGuide
    self.constraints.append(header.topAnchor.constraint(equalTo: margin.topAnchor, constant: 0))
    self.constraints.append(header.bottomAnchor.constraint(equalTo: smallGridView.topAnchor, constant: 0))
    self.constraints.append(header.leftAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.constraints.append(header.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
    self.constraints.append(header.heightAnchor.constraint(equalToConstant: 44))
    
    self.constraints.append(instructionsLabel.topAnchor.constraint(equalTo: smallGridView.bottomAnchor, constant: 0))
    self.constraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: bigGridView.topAnchor, constant: 0))
    self.constraints.append(instructionsLabel.leftAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.constraints.append(instructionsLabel.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
  }
  
  private func setupOtherViewsConstraintsInLandscapeEnvironment() {
    let margin = view.layoutMarginsGuide
    self.constraints.append(header.topAnchor.constraint(equalTo: margin.topAnchor, constant: 0))
    self.constraints.append(header.bottomAnchor.constraint(equalTo: smallGridView.topAnchor, constant: 0))
    self.constraints.append(header.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 0))
    self.constraints.append(header.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
    
    self.constraints.append(instructionsLabel.leftAnchor.constraint(equalTo: smallGridView.leftAnchor, constant: 0))
    self.constraints.append(instructionsLabel.topAnchor.constraint(equalTo: smallGridView.bottomAnchor, constant: 0))
    self.constraints.append(instructionsLabel.rightAnchor.constraint(equalTo: smallGridView.rightAnchor, constant: 0))
    self.constraints.append(instructionsLabel.heightAnchor.constraint(equalToConstant: 50))
  }
  
  private func setupBigGridViewConstraintsInPortraitEnvironmen(padding: CGFloat) {
    let margin = view.layoutMarginsGuide
    self.constraints.append(bigGridView.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: padding))
    self.constraints.append(bigGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -padding))
    self.constraints.append(bigGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: 0))
    self.constraints.append(bigGridView.heightAnchor.constraint(equalTo: bigGridView.widthAnchor))
  }
  
  private func setupBigGridViewConstraintInLandscapeEnvironment(padding: CGFloat) {
    let margin = view.layoutMarginsGuide
    self.constraints.append(bigGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -padding))
    self.constraints.append(bigGridView.topAnchor.constraint(equalTo: margin.topAnchor, constant: padding))
    self.constraints.append(bigGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: 0))
    self.constraints.append(bigGridView.widthAnchor.constraint(equalTo: bigGridView.heightAnchor))
    self.constraints.append(smallGridView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 0))
  }
  
  private func setupSmallGridViewConstraintsInPortraitEnvironment(padding: CGFloat) {
    let smallGridWidth = view.bounds.width - view.layoutMargins.left - view.layoutMargins.right - padding * 2
    let smallGridHeight = smallGridViewHeight(tileWidth: smallTileWidth(width: smallGridWidth))
    
    self.constraints.append(smallGridView.heightAnchor.constraint(equalToConstant: smallGridHeight))
    self.constraints.append(smallGridView.leftAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.constraints.append(smallGridView.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
  }
  
  private func setupSmallGridViewConstraintsInLandscapeEnvironment(padding: CGFloat) {
    let smallGridWidth = view.bounds.width - view.layoutMargins.left - view.layoutMargins.right - view.bounds.height
      + view.layoutMargins.bottom + view.layoutMargins.top + padding * 2
    let smallGridHeight = smallGridViewHeight(tileWidth: smallTileWidth(width: smallGridWidth))
    
    self.constraints.append(smallGridView.rightAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.constraints.append(smallGridView.heightAnchor.constraint(equalToConstant: smallGridHeight))
    self.constraints.append(smallGridView.topAnchor.constraint(equalTo: bigGridView.topAnchor, constant: 0))
  }
  
  func smallTileWidth(width: CGFloat) -> CGFloat {
    let countByRow =  CGFloat.init(Constant.Tiles.Small.countByRow )
    let tileWidth = (width - Constant.Tiles.Small.gapLength * (countByRow + 1)) / countByRow
    return tileWidth
  }
  
  private func smallGridViewHeight(tileWidth: CGFloat) -> CGFloat {
    let numberOfRow = (CGFloat(images.count) / CGFloat(Constant.Tiles.Small.countByRow)).rounded(.up)
    return tileWidth * numberOfRow + (numberOfRow + 1) * Constant.Tiles.Small.gapLength
  }

  private func clearAllConstraints() {
    NSLayoutConstraint.deactivate(self.constraints)
//    NSLayoutConstraint.deactivate(self.commonConstraints)
    self.constraints.removeAll()
//    self.commonConstraints.removeAll()
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
        if bigGridView.frame.contains(view.center) {
          let max = bigGridView.subviews.count - 1
          for index in 0...max {
            let tile = bigGridView.subviews[index]
            let center = convertCoordinates(of: view.center, into: bigGridView)
            if tile.frame.contains(center) {
              if bigGridModel.isTileFree(at: index) && index != bigGridModel.position(id: tag) {
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
          if let _ = bigGridModel.position(id: tag) { self.score += 1 }
          bigGridModel.updatePosition(id: tag, position: nil)
          let position = smallGridModel.getFreeTilePosition()
          smallGridModel.updatePosition(id: tag, position: position)
        }
        
        refreshLayout()
        
        if bigGridModel.isFull() {
          if bigGridModel.isMatching() {
            self.instructionsLabel.text = "GAME OVER"
            self.instructionsLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 35)
            self.instructionsLabel.textColor = UIColor.red
            for imageView in imageViews {
              imageView.isUserInteractionEnabled = false
            }
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displaySharingOptions))
            self.instructionsLabel.addGestureRecognizer(tapGestureRecognizer)
            self.instructionsLabel.isUserInteractionEnabled = true
          }
        }
      }
    }
  }
  
  @objc func displaySharingOptions() {
    let text = "My score is \(score)"
    let items = [hintImage as Any, text as Any]
    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = view
    present(activityViewController, animated: true, completion: nil)
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
    if tag == 0 { return Constant.Tiles.Small.gapLength }
    return Constant.Tiles.Big.gapLength
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
    if tag == 0 { return Constant.Tiles.Small.countByRow }
    return Constant.Tiles.Big.countByRow
  }
}

extension PlayViewController: HeaderViewDelegate {
  func newGameButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
}

//
//  PlayView.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/07/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol PlayViewDelegate: AnyObject {
  func moveImageView(_ sender: UIPanGestureRecognizer)
}

class PlayView: UIView {
  
  weak var delegate: PlayViewDelegate?
  
  var containerGridView: GridView!
  var puzzleGridView: GridView!
  var header: HeaderView!
  
  var imageViews: [ImageView]!
  var instructionsLabel: UILabel!
  
  var hintView: HintView!
  
  private var unsharedConstraints: [NSLayoutConstraint]!
  private var commonConstraints: [NSLayoutConstraint]!
  
 required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(hintImage: UIImage, images: [Image]!) {
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    
    self.unsharedConstraints = [NSLayoutConstraint]()
    self.commonConstraints = [NSLayoutConstraint]()
    
    self.isUserInteractionEnabled = true
    self.backgroundColor = UIColor.white
    
    instantiateSubviews(hintImage: hintImage, images: images)
    addSubviews()
    detectUserActions()
    setupHintViewConstraints()
    setupCommonConstraintsPriority()
    NSLayoutConstraint.activate(self.commonConstraints)
  }
    
  func setup(parentView view: UIView) {
    view.backgroundColor = UIColor.white
    view.addSubview(self)
    let safeArea = view.safeAreaLayoutGuide
    self.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
    self.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
    self.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
    self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
  }
  
  func setupConstraintsInPortraitEnvironment(offset: CGFloat) {
    setupBigGridViewConstraintsInPortraitEnvironmen(offset: offset)
    setupSmallGridViewConstraintsInPortraitEnvironment(offset: offset)
    setupOtherViewsConstraintsInPortraitEnvironment()
  }
  
  func setupConstraintsInLandscapeEnvironment(offset: CGFloat) {
    setupBigGridViewConstraintInLandscapeEnvironment(offset: offset)
    setupSmallGridViewConstraintsInLandscapeEnvironment(offset: offset)
    setupOtherViewsConstraintsInLandscapeEnvironment()
  }
  
  func deactivateConstraints() {
    NSLayoutConstraint.deactivate(self.unsharedConstraints)
    self.unsharedConstraints.removeAll()
  }
  
  func activateConstraints() {
    setupConstraintsPriority()
    NSLayoutConstraint.activate(self.unsharedConstraints)
  }
  
  func updateLabels(fontSize: CGFloat) {
    instructionsLabel.font = instructionsLabel.font.withSize(fontSize)
    
    header.scoreLabel.font = header.scoreLabel.font.withSize(fontSize)
    header.newGameButton.titleLabel?.font = header.newGameButton.titleLabel?.font.withSize(fontSize)
    header.gridyLabel.font = header.gridyLabel.font.withSize(fontSize * 2)
    header.movesLabel.font = header.movesLabel.font.withSize(fontSize)
  }
  
  func convertFrame(of tile: UIView, in view: UIView) -> CGRect {
    let width = tile.frame.width
    let height = tile.frame.height
    let origin = convertCoordinates(of: tile.frame.origin, from: view)
    let size = CGSize(width: width, height: height)
    return CGRect(origin: origin, size: size)
  }
  
  func convertCoordinates(of point: CGPoint, from view: UIView) -> CGPoint {
    let x = point.x + view.frame.origin.x
    let y = point.y + view.frame.origin.y
    return CGPoint(x: x, y: y)
  }
  
  func convertCoordinates(of point: CGPoint, into view: UIView) -> CGPoint {
    let x = point.x - view.frame.origin.x
    let y = point.y - view.frame.origin.y
    return CGPoint(x: x, y: y)
  }
  
  
  private func setupConstraintsPriority() {
    for constraint in unsharedConstraints {
      constraint.priority = .defaultHigh
    }
  }
  
  private func instantiateSubviews(hintImage: UIImage, images: [Image]!) {
    instantiateViews(hintImage: hintImage)
    instantiateImageViews(images: images)
    instantiateGridViews()
  }
  
  private func addSubviews() {
    self.addSubview(header)
    self.addSubview(puzzleGridView)
    self.addSubview(containerGridView)
    self.addSubview(instructionsLabel)
    
    for imageView in imageViews {
      self.addSubview(imageView)
    }
    self.addSubview(hintView)
  }
  
  private func setupCommonConstraintsPriority() {
    for constraint in commonConstraints {
      constraint.priority = .init(751)
    }
  }
  
  private func instantiateGridViews() {
    containerGridView = GridView(tag: 0, eyeOption: true)
    containerGridView.backgroundColor = UIColor.white
    puzzleGridView = GridView(tag: 1)
    puzzleGridView.backgroundColor = GridyColor.janna
    
    containerGridView.translatesAutoresizingMaskIntoConstraints = false
    puzzleGridView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func instantiateViews(hintImage: UIImage) {
    self.instructionsLabel = UILabel()
    instructionsLabel.text = "Drag pieces to the grid.\nSwipe out of the grid to undo"
    instructionsLabel.numberOfLines = 0
    instructionsLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 1)
    instructionsLabel.textAlignment = .center
    instructionsLabel.adjustsFontSizeToFitWidth = true
    
    self.header = HeaderView()
    
    self.hintView = HintView(image: hintImage)
    hintView.isUserInteractionEnabled = false
    hintView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    hintView.imageView.alpha = 0
    
    header.translatesAutoresizingMaskIntoConstraints = false
    instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
    hintView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func instantiateImageViews(images: [Image]!) {
    self.imageViews = Array(repeating: ImageView(), count: images.count)
    for image in images {
      let imageView = ImageView.init(image: image.image)
      imageView.tag = image.id
      imageView.translatesAutoresizingMaskIntoConstraints = true
      self.imageViews[image.id] = imageView
    }
  }
  
  private func setupHintViewConstraints() {
    self.commonConstraints.append(hintView.topAnchor.constraint(equalTo: self.topAnchor))
    self.commonConstraints.append(hintView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
    self.commonConstraints.append(hintView.leftAnchor.constraint(equalTo: self.leftAnchor))
    self.commonConstraints.append(hintView.rightAnchor.constraint(equalTo: self.rightAnchor))
  }
  
  private func setupOtherViewsConstraintsInPortraitEnvironment() {
    if let margin = self.superview?.layoutMarginsGuide {
      self.unsharedConstraints.append(header.topAnchor.constraint(equalTo: margin.topAnchor, constant: 0))
      self.unsharedConstraints.append(header.bottomAnchor.constraint(equalTo: containerGridView.topAnchor, constant: -10))
      self.unsharedConstraints.append(header.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor, constant: 0))
      self.unsharedConstraints.append(header.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor, constant: 0))
      
      self.unsharedConstraints.append(instructionsLabel.topAnchor.constraint(equalTo: containerGridView.bottomAnchor, constant: 0))
      self.unsharedConstraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: puzzleGridView.topAnchor, constant: 0))
      self.unsharedConstraints.append(instructionsLabel.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor, constant: 0))
      self.unsharedConstraints.append(instructionsLabel.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor, constant: 0))
    }
  }
  
  private func setupOtherViewsConstraintsInLandscapeEnvironment() {
    if let margin = self.superview?.layoutMarginsGuide {
      self.unsharedConstraints.append(header.topAnchor.constraint(equalTo: margin.topAnchor, constant: 5))
      self.unsharedConstraints.append(header.bottomAnchor.constraint(equalTo: containerGridView.topAnchor, constant: -10))
      self.unsharedConstraints.append(header.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 0))
      self.unsharedConstraints.append(header.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor, constant: 0))
      
      self.unsharedConstraints.append(instructionsLabel.topAnchor.constraint(equalTo: containerGridView.bottomAnchor, constant: 0))
      self.unsharedConstraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: puzzleGridView.bottomAnchor, constant: 0))
      self.unsharedConstraints.append(instructionsLabel.leftAnchor.constraint(equalTo: containerGridView.leftAnchor, constant: 0))
      self.unsharedConstraints.append(instructionsLabel.rightAnchor.constraint(equalTo: containerGridView.rightAnchor, constant: 0))
    }
  }
  
  private func setupBigGridViewConstraintsInPortraitEnvironmen(offset: CGFloat) {
    if let margin = self.superview?.layoutMarginsGuide {
      self.unsharedConstraints.append(puzzleGridView.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: offset))
      self.unsharedConstraints.append(puzzleGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -offset))
      self.unsharedConstraints.append(puzzleGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: 0))
      self.unsharedConstraints.append(puzzleGridView.heightAnchor.constraint(equalTo: puzzleGridView.widthAnchor))
    }
  }
  
  private func setupBigGridViewConstraintInLandscapeEnvironment(offset: CGFloat) {
    if let margin = self.superview?.layoutMarginsGuide {
      self.unsharedConstraints.append(puzzleGridView.topAnchor.constraint(equalTo: margin.topAnchor, constant: offset))
      self.unsharedConstraints.append(puzzleGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -offset))
      self.unsharedConstraints.append(puzzleGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: 0))
      self.unsharedConstraints.append(puzzleGridView.widthAnchor.constraint(equalTo: puzzleGridView.heightAnchor))
    }
  }
  
  private func setupSmallGridViewConstraintsInPortraitEnvironment(offset: CGFloat) {
    if let superview = self.superview {
      let containerGridWidth = superview.bounds.width - superview.layoutMargins.left - superview.layoutMargins.right - offset * 2
      let containerGridHeight = containerGridViewHeight(tileWidth: containerTileWidth(width: containerGridWidth))
      
      self.unsharedConstraints.append(containerGridView.heightAnchor.constraint(equalToConstant: containerGridHeight))
      self.unsharedConstraints.append(containerGridView.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor, constant: 0))
      self.unsharedConstraints.append(containerGridView.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor, constant: 0))
    }
  }
  
  private func setupSmallGridViewConstraintsInLandscapeEnvironment(offset: CGFloat) {
    if let superview = self.superview {
      let containerGridWidth = superview.bounds.width - superview.layoutMargins.left - superview.layoutMargins.right - superview.bounds.height
        + superview.layoutMargins.bottom + superview.layoutMargins.top + offset * 2
      let containerGridHeight = containerGridViewHeight(tileWidth: containerTileWidth(width: containerGridWidth))
      
      self.unsharedConstraints.append(containerGridView.heightAnchor.constraint(equalToConstant: containerGridHeight))
      self.unsharedConstraints.append(containerGridView.topAnchor.constraint(equalTo: puzzleGridView.topAnchor, constant: 0))
      self.unsharedConstraints.append(containerGridView.rightAnchor.constraint(equalTo: puzzleGridView.leftAnchor, constant: 0))
      self.unsharedConstraints.append(containerGridView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 0))
    }
  }
  
  private func containerTileWidth(width: CGFloat) -> CGFloat {
    let countByRow =  CGFloat.init(Constant.Tiles.Container.countByRow )
    let tileWidth = (width - Constant.Tiles.Container.gapLength * (countByRow + 1)) / countByRow
    return tileWidth
  }
  
  private func containerGridViewHeight(tileWidth: CGFloat) -> CGFloat {
    let numberOfRow = (CGFloat(imageViews.count) / CGFloat(Constant.Tiles.Container.countByRow)).rounded(.up)
    return tileWidth * numberOfRow + (numberOfRow + 1) * Constant.Tiles.Container.gapLength
  }
  
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
    delegate?.moveImageView(sender)
  }
}

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
  
  var smallGridView: GridView!
  var bigGridView: GridView!
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
    self.addSubview(bigGridView)
    self.addSubview(smallGridView)
    self.addSubview(instructionsLabel)
    
    for imageView in imageViews {
      self.addSubview(imageView)
    }
    self.addSubview(hintView)
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
  
  private func setupCommonConstraintsPriority() {
    for constraint in commonConstraints {
      constraint.priority = .init(751)
    }
  }
  
  private func instantiateGridViews() {
    smallGridView = GridView(tag: 0, eyeOption: true)
    smallGridView.backgroundColor = UIColor.red
    bigGridView = GridView(tag: 1)
    bigGridView.backgroundColor = GridyColor.pixieGreen
    
    smallGridView.translatesAutoresizingMaskIntoConstraints = false
    bigGridView.translatesAutoresizingMaskIntoConstraints = false
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
    let margin = self.layoutMarginsGuide
    self.commonConstraints.append(hintView.topAnchor.constraint(equalTo: margin.topAnchor))
    self.commonConstraints.append(hintView.bottomAnchor.constraint(equalTo: margin.bottomAnchor))
    self.commonConstraints.append(hintView.leftAnchor.constraint(equalTo: margin.leftAnchor))
    self.commonConstraints.append(hintView.rightAnchor.constraint(equalTo: margin.rightAnchor))
  }
  
  private func setupOtherViewsConstraintsInPortraitEnvironment() {
    let margin = self.layoutMarginsGuide
    self.unsharedConstraints.append(header.topAnchor.constraint(equalTo: margin.topAnchor, constant: 0))
    self.unsharedConstraints.append(header.bottomAnchor.constraint(equalTo: smallGridView.topAnchor, constant: -10))
    self.unsharedConstraints.append(header.leftAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.unsharedConstraints.append(header.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
    
    self.unsharedConstraints.append(instructionsLabel.topAnchor.constraint(equalTo: smallGridView.bottomAnchor, constant: 0))
    self.unsharedConstraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: bigGridView.topAnchor, constant: 0))
    self.unsharedConstraints.append(instructionsLabel.leftAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.unsharedConstraints.append(instructionsLabel.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
  }
  
  private func setupOtherViewsConstraintsInLandscapeEnvironment() {
    let margin = self.layoutMarginsGuide
    self.unsharedConstraints.append(header.topAnchor.constraint(equalTo: margin.topAnchor, constant: 5))
    self.unsharedConstraints.append(header.bottomAnchor.constraint(equalTo: smallGridView.topAnchor, constant: -10))
    self.unsharedConstraints.append(header.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 0))
    self.unsharedConstraints.append(header.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
    
    self.unsharedConstraints.append(instructionsLabel.topAnchor.constraint(equalTo: smallGridView.bottomAnchor, constant: 0))
    self.unsharedConstraints.append(instructionsLabel.bottomAnchor.constraint(equalTo: bigGridView.bottomAnchor, constant: 0))
    self.unsharedConstraints.append(instructionsLabel.leftAnchor.constraint(equalTo: smallGridView.leftAnchor, constant: 0))
    self.unsharedConstraints.append(instructionsLabel.rightAnchor.constraint(equalTo: smallGridView.rightAnchor, constant: 0))
  }
  
  private func setupBigGridViewConstraintsInPortraitEnvironmen(offset: CGFloat) {
    let margin = self.layoutMarginsGuide
    self.unsharedConstraints.append(bigGridView.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: offset))
    self.unsharedConstraints.append(bigGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: -offset))
    self.unsharedConstraints.append(bigGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: 0))
    self.unsharedConstraints.append(bigGridView.heightAnchor.constraint(equalTo: bigGridView.widthAnchor))
  }
  
  private func setupBigGridViewConstraintInLandscapeEnvironment(offset: CGFloat) {
    let margin = self.layoutMarginsGuide
    self.unsharedConstraints.append(bigGridView.topAnchor.constraint(equalTo: margin.topAnchor, constant: offset))
    self.unsharedConstraints.append(bigGridView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -offset))
    self.unsharedConstraints.append(bigGridView.rightAnchor.constraint(equalTo: margin.rightAnchor, constant: 0))
    self.unsharedConstraints.append(bigGridView.widthAnchor.constraint(equalTo: bigGridView.heightAnchor))
  }
  
  private func setupSmallGridViewConstraintsInPortraitEnvironment(offset: CGFloat) {
    let smallGridWidth = self.bounds.width - self.layoutMargins.left - self.layoutMargins.right - offset * 2
    let smallGridHeight = smallGridViewHeight(tileWidth: smallTileWidth(width: smallGridWidth))
    
    self.unsharedConstraints.append(smallGridView.heightAnchor.constraint(equalToConstant: smallGridHeight))
    self.unsharedConstraints.append(smallGridView.leftAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.unsharedConstraints.append(smallGridView.rightAnchor.constraint(equalTo: bigGridView.rightAnchor, constant: 0))
  }
  
  private func setupSmallGridViewConstraintsInLandscapeEnvironment(offset: CGFloat) {
    let smallGridWidth = self.bounds.width - self.layoutMargins.left - self.layoutMargins.right - self.bounds.height
      + self.layoutMargins.bottom + self.layoutMargins.top + offset * 2
    let smallGridHeight = smallGridViewHeight(tileWidth: smallTileWidth(width: smallGridWidth))
    
    self.unsharedConstraints.append(smallGridView.heightAnchor.constraint(equalToConstant: smallGridHeight))
    self.unsharedConstraints.append(smallGridView.topAnchor.constraint(equalTo: bigGridView.topAnchor, constant: 0))
    self.unsharedConstraints.append(smallGridView.rightAnchor.constraint(equalTo: bigGridView.leftAnchor, constant: 0))
    self.unsharedConstraints.append(smallGridView.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 0))
  }
  
  private func smallTileWidth(width: CGFloat) -> CGFloat {
    let countByRow =  CGFloat.init(Constant.Tiles.Small.countByRow )
    let tileWidth = (width - Constant.Tiles.Small.gapLength * (countByRow + 1)) / countByRow
    return tileWidth
  }
  
  private func smallGridViewHeight(tileWidth: CGFloat) -> CGFloat {
    let numberOfRow = (CGFloat(imageViews.count) / CGFloat(Constant.Tiles.Small.countByRow)).rounded(.up)
    return tileWidth * numberOfRow + (numberOfRow + 1) * Constant.Tiles.Small.gapLength
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

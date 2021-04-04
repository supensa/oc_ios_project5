//
//  PlayView.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/07/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol PlayViewDelegate: AnyObject {
  func handlePuzzleViewDrag(_ gestureRecognizer: UIPanGestureRecognizer)
  func handleShareButtonTapped()
}

class PlayView: UIView {
  
  weak var delegate: PlayViewDelegate?
  
  var puzzleGridView = PuzzleGridView()
  var headerView = HeaderView()
  var centeringView = UIView()
  lazy var containerGridView: ContainerGridView = {
    let view = ContainerGridView()
    view.delegate = self
    return view
  }()
  
  var shareButton: UIButton?
  
  let instructionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    label.text = Constant.String.instruction
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  private var isLandscapeOrientation: Bool {
    guard let superview = self.superview else { return false }
    return superview.bounds.width > superview.bounds.height
  }
  
  var puzzlePieceViews = [UIImageView]()
  var puzzlePieceViewConstraints = [Int: [NSLayoutConstraint]]()
  
  var hintView: HintView!
  
  private var landscapeConstraints = [NSLayoutConstraint]()
  private var portraitConstraints = [NSLayoutConstraint]()
  private var regularPortraitConstraints = [NSLayoutConstraint]()
  private var regularLandscapeConstraints = [NSLayoutConstraint]()
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(hintImage: UIImage, puzzlePieceViews: [UIImageView]) {
    super.init(frame: .zero)
    
    hintView = HintView(image: hintImage)
    
    addSubviews()
    initialLayout(for: puzzlePieceViews)
    setupGestureRecognizers()
    updateLayoutAccordingToSizeClass()
  }
  
  // Setup and update constraints according to sizeClass
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let horizontaSizeClassChanged = previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
    let verticalSizeClassChanged = previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass
    
    if verticalSizeClassChanged || horizontaSizeClassChanged {
      updateLayoutAccordingToSizeClass()
    }
  }
  
  func place(_ puzzlePieceView: UIImageView, inside tile: UIView) {
    let id = puzzlePieceView.tag
    
    if let oldConstraints = self.puzzlePieceViewConstraints[id] {
      NSLayoutConstraint.deactivate(oldConstraints)
      puzzlePieceView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    let newConstraints = [
      puzzlePieceView.topAnchor.constraint(equalTo: tile.topAnchor, constant: -1/2),
      puzzlePieceView.leftAnchor.constraint(equalTo: tile.leftAnchor, constant: -1/2),
      puzzlePieceView.bottomAnchor.constraint(equalTo: tile.bottomAnchor, constant: 1/2),
      puzzlePieceView.rightAnchor.constraint(equalTo: tile.rightAnchor, constant: 1/2)
    ]
    
    NSLayoutConstraint.setAndActivate(newConstraints)
    
    self.puzzlePieceViewConstraints[id] = newConstraints
  }
  
  func activateRegularPortraitLayout() {
    NSLayoutConstraint.deactivate(self.landscapeConstraints)
    NSLayoutConstraint.deactivate(self.portraitConstraints)
    NSLayoutConstraint.deactivate(self.regularLandscapeConstraints)
    NSLayoutConstraint.setAndActivate(self.regularPortraitConstraints)
    headerView.setBigFontSize()
    instructionLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 30)
    shareButton?.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 30)
  }
  
  func activateRegularLandscapeLayout() {
    NSLayoutConstraint.deactivate(self.landscapeConstraints)
    NSLayoutConstraint.deactivate(self.portraitConstraints)
    NSLayoutConstraint.deactivate(self.regularPortraitConstraints)
    NSLayoutConstraint.setAndActivate(self.regularLandscapeConstraints)
    headerView.setBigFontSize()
    instructionLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 30)
    shareButton?.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 30)
  }
  
  func activatePortraitLayout() {
    NSLayoutConstraint.deactivate(self.landscapeConstraints)
    NSLayoutConstraint.deactivate(self.regularPortraitConstraints)
    NSLayoutConstraint.deactivate(self.regularLandscapeConstraints)
    NSLayoutConstraint.setAndActivate(self.portraitConstraints)
    headerView.setNormalFontSize()
    instructionLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    shareButton?.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
  }
  
  func activateLandscapeLayout() {
    NSLayoutConstraint.deactivate(self.portraitConstraints)
    NSLayoutConstraint.deactivate(self.regularPortraitConstraints)
    NSLayoutConstraint.deactivate(self.regularLandscapeConstraints)
    NSLayoutConstraint.setAndActivate(self.landscapeConstraints)
    headerView.setNormalFontSize()
    instructionLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
    shareButton?.titleLabel?.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 15)
  }
  
  func convertCenterPointCoordinateSystem(of view: UIView, to containerView: UIView) -> CGPoint {
    let newX = view.frame.origin.x - containerView.frame.origin.x
    let newY = view.frame.origin.y - containerView.frame.origin.y
    
    let centerX = view.frame.width/2 + newX
    let centerY = view.frame.height/2 + newY
    
    return CGPoint(x: centerX, y: centerY)
  }
  
  func layoutEndGameMode() {
    containerGridView.isUserInteractionEnabled = false
    removeUserInteraction(from: puzzlePieceViews)
    instructionLabel.isHidden = true
    addSharePuzzleButton()
  }
  
  private func updateLayoutAccordingToSizeClass() {
    let sizeClass = (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass)
    switch sizeClass {
    case (.compact, .regular):
      self.activatePortraitLayout()
      break
    case (.compact, .compact), (.regular,.compact):
      self.activateLandscapeLayout()
      break
    case (.regular, .regular):
      if isLandscapeOrientation {
        self.activateRegularLandscapeLayout()
      }
      else {
        self.activateRegularPortraitLayout()
      }
      break
    default:
      break
    }
  }
  
  private func removeUserInteraction(from views: [UIView]) {
    for view in views {
      view.isUserInteractionEnabled = false
    }
  }
  
  private func addSubviews() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white
    
    headerView.backgroundColor = UIColor.clear
    
    addSubview(centeringView)
    addSubview(puzzleGridView)
    addSubview(headerView)
    addSubview(containerGridView)
    addSubview(instructionLabel)
    addSubview(hintView)
    
    setAndActivateCenteringView()
    setAndActivateHintViewConstraints()
    
    setupLandscapeConstraints()
    setupPortraitConstraints()
    setupRegularRegularPortraitConstraints()
    setupRegularRegularLandscapeConstraints()
  }
  
  private func setupGestureRecognizers() {
    setupPuzzlePiecesGestureRecognizers()
  }
  
  private func initialLayout(for puzzlePieceViews: [UIImageView]) {
    
    for i in 0...puzzlePieceViews.count - 1 {
      if let tile = containerGridView.getTile(from: i) {
        
        let puzzlePieceView = puzzlePieceViews[i]
        puzzlePieceView.isUserInteractionEnabled = true
        
        addSubview(puzzlePieceView)
        place(puzzlePieceView, inside: tile)
        
        self.puzzlePieceViews.append(puzzlePieceView)
      }
    }
  }
}

// MARK: - Layout constraints (Universal)
extension PlayView {
  private func setAndActivateHintViewConstraints() {
    NSLayoutConstraint.setAndActivate([
      hintView.topAnchor.constraint(equalTo: self.topAnchor, constant: -1),
      hintView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 1),
      hintView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -1),
      hintView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 1)
      ])
  }
  
  private func setAndActivateCenteringView() {
    NSLayoutConstraint.setAndActivate([
      centeringView.leftAnchor.constraint(equalTo: self.leftAnchor),
      centeringView.rightAnchor.constraint(equalTo: self.rightAnchor),
      centeringView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      centeringView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
      ])
  }
}

// MARK: - Layout constraints (iPad + iPhone)
extension PlayView {
  private func setupRegularRegularPortraitConstraints() {
    
    let puzzleGridViewConstraints = [
      puzzleGridView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
      puzzleGridView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2),
      puzzleGridView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      puzzleGridView.widthAnchor.constraint(equalTo: puzzleGridView.heightAnchor, constant: 0)
    ]
    
    let headerViewConstraints = [
      headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      headerView.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor, constant: 0),
      headerView.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor, constant: 0),
      headerView.heightAnchor.constraint(equalToConstant: 60)
    ]
    
    let containerGridViewConstraints = [
      containerGridView.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor),
      containerGridView.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor),
      containerGridView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
      containerGridView.heightAnchor.constraint(equalTo: containerGridView.widthAnchor, multiplier: 1/2)
    ]
    
    let instructionLabelConstraints = [
      instructionLabel.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor),
      instructionLabel.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor),
      instructionLabel.topAnchor.constraint(equalTo: containerGridView.bottomAnchor),
      instructionLabel.bottomAnchor.constraint(equalTo: puzzleGridView.topAnchor)
    ]
    
    self.regularPortraitConstraints.append(contentsOf: puzzleGridViewConstraints)
    self.regularPortraitConstraints.append(contentsOf: headerViewConstraints)
    self.regularPortraitConstraints.append(contentsOf: containerGridViewConstraints)
    self.regularPortraitConstraints.append(contentsOf: instructionLabelConstraints)
  }
  
  private func setupRegularRegularLandscapeConstraints() {
    
    let puzzleGridViewConstraints = [
      puzzleGridView.centerYAnchor.constraint(equalTo: centeringView.centerYAnchor, constant: 0),
      puzzleGridView.rightAnchor.constraint(equalTo: centeringView.rightAnchor, constant: 0),
      puzzleGridView.heightAnchor.constraint(equalTo: centeringView.widthAnchor, multiplier: 1/2),
      puzzleGridView.widthAnchor.constraint(equalTo: centeringView.widthAnchor, multiplier: 1/2)
    ]
    
    let headerViewConstraints = [
      headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      headerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
      headerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
    ]
    
    let containerGridViewConstraints = [
      containerGridView.topAnchor.constraint(equalTo: puzzleGridView.topAnchor, constant: 0),
      containerGridView.leftAnchor.constraint(equalTo: centeringView.leftAnchor),
      containerGridView.widthAnchor.constraint(equalTo: centeringView.widthAnchor, multiplier: 1/2, constant: -16),
      containerGridView.heightAnchor.constraint(equalTo: containerGridView.widthAnchor, multiplier: 1/2)
    ]
    
    let instructionLabelConstraints = [
      instructionLabel.leftAnchor.constraint(equalTo: containerGridView.leftAnchor),
      instructionLabel.rightAnchor.constraint(equalTo: containerGridView.rightAnchor),
      instructionLabel.topAnchor.constraint(equalTo: containerGridView.bottomAnchor),
      instructionLabel.bottomAnchor.constraint(equalTo: puzzleGridView.bottomAnchor)
    ]
    
    self.regularLandscapeConstraints.append(contentsOf: puzzleGridViewConstraints)
    self.regularLandscapeConstraints.append(contentsOf: headerViewConstraints)
    self.regularLandscapeConstraints.append(contentsOf: containerGridViewConstraints)
    self.regularLandscapeConstraints.append(contentsOf: instructionLabelConstraints)
  }
  
  private func setupPortraitConstraints() {
    
    let puzzleGridViewConstraints = [
      puzzleGridView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
      puzzleGridView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
      puzzleGridView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
      puzzleGridView.heightAnchor.constraint(equalTo: puzzleGridView.widthAnchor, constant: 0)
    ]
    
    let headerViewConstraints = [
      headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      headerView.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor, constant: 0),
      headerView.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor, constant: 0)
    ]
    
    let containerGridViewConstraints = [
      containerGridView.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor),
      containerGridView.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor),
      containerGridView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
      containerGridView.heightAnchor.constraint(equalTo: containerGridView.widthAnchor, multiplier: 1/2)
    ]
    
    let instructionLabelConstraints = [
      instructionLabel.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor),
      instructionLabel.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor),
      instructionLabel.topAnchor.constraint(equalTo: containerGridView.bottomAnchor),
      instructionLabel.bottomAnchor.constraint(equalTo: puzzleGridView.topAnchor)
    ]
    
    changePriority(contraints: headerViewConstraints, priority: 800)
    changePriority(contraints: containerGridViewConstraints, priority: 800)
    changePriority(contraints: instructionLabelConstraints, priority: 800)
    
    self.portraitConstraints.append(contentsOf: puzzleGridViewConstraints)
    self.portraitConstraints.append(contentsOf: instructionLabelConstraints)
    self.portraitConstraints.append(contentsOf: containerGridViewConstraints)
    self.portraitConstraints.append(contentsOf: headerViewConstraints)
  }
  
  private func setupLandscapeConstraints() {
    
    let puzzleGridViewConstraints = [
      puzzleGridView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
      puzzleGridView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
      puzzleGridView.rightAnchor.constraint(equalTo: centeringView.rightAnchor, constant: 0),
      puzzleGridView.widthAnchor.constraint(equalTo: puzzleGridView.heightAnchor, constant: 0)
    ]
    
    let headerViewConstraints = [
      headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      headerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
      headerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
    ]
    
    let containerGridViewConstraints = [
      containerGridView.leftAnchor.constraint(equalTo: self.leftAnchor),
      containerGridView.rightAnchor.constraint(equalTo: puzzleGridView.leftAnchor, constant: -16),
      containerGridView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
      containerGridView.heightAnchor.constraint(equalTo: containerGridView.widthAnchor, multiplier: 1/2)
    ]
    
    let instructionLabelConstraints = [
      instructionLabel.leftAnchor.constraint(equalTo: containerGridView.leftAnchor),
      instructionLabel.rightAnchor.constraint(equalTo: containerGridView.rightAnchor),
      instructionLabel.topAnchor.constraint(equalTo: containerGridView.bottomAnchor),
      instructionLabel.bottomAnchor.constraint(equalTo: puzzleGridView.bottomAnchor)
    ]
    
    changePriority(contraints: headerViewConstraints, priority: 800)
    changePriority(contraints: containerGridViewConstraints, priority: 800)
    changePriority(contraints: instructionLabelConstraints, priority: 800)
    
    self.landscapeConstraints.append(contentsOf: puzzleGridViewConstraints)
    self.landscapeConstraints.append(contentsOf: headerViewConstraints)
    self.landscapeConstraints.append(contentsOf: containerGridViewConstraints)
    self.landscapeConstraints.append(contentsOf: instructionLabelConstraints)
  }
  
  private func changePriority(contraints: [NSLayoutConstraint], priority: Float) {
    for contraint in constraints {
      contraint.priority = UILayoutPriority(priority)
    }
  }
}

// MARK: - ContainerGridView delegate
extension PlayView: ContainerGridViewDelegate {
  func eyeViewTapped() {
    bringSubviewToFront(hintView)
    hintView.appearsTemporarily(for: 2)
  }
}

// MARK: - PuzzlePieces gesture recognizer logic
extension PlayView {
  private func setupPuzzlePiecesGestureRecognizers() {
    for puzzlePieceView in puzzlePieceViews {
      let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(movePuzzlePieceView))
      puzzlePieceView.addGestureRecognizer(panGestureRecognizer)
    }
  }
  
  @objc private func movePuzzlePieceView(_ gestureRecognizer: UIPanGestureRecognizer) {
    delegate?.handlePuzzleViewDrag(gestureRecognizer)
  }
}

// MARK: - ShareButton creation
extension PlayView {
  private func addSharePuzzleButton() {
    shareButton = UIButton(type: .custom)
    shareButton?.layer.cornerRadius = 5
    shareButton?.clipsToBounds = true
    shareButton?.backgroundColor = UIColor.vistaBlue
    shareButton?.setTitleColor(.white, for: .normal)
    shareButton?.setTitle(Constant.String.shareButtonTitle, for: .normal)
    shareButton?.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    
    let centeringView = UIView()
    
    addSubview(centeringView)
    addSubview(shareButton!)
    
    bringPuzzleToFront()
    
    setupPortraitConstraintsForShareButton(centeringView)
    setupLandscapeConstraintsForShareButton()
    
    updateLayoutAccordingToSizeClass()
  }
  
  @objc private func shareButtonTapped() {
    delegate?.handleShareButtonTapped()
  }
  
  private func setupPortraitConstraintsForShareButton(_ centeringView: UIView) {
    guard let shareButton = shareButton else { fatalError("Share Button is nil") }
    
    var portraitConstraints = [
      centeringView.topAnchor.constraint(equalTo: containerGridView.bottomAnchor),
      centeringView.bottomAnchor.constraint(equalTo: puzzleGridView.topAnchor),
      centeringView.leftAnchor.constraint(equalTo: puzzleGridView.leftAnchor),
      centeringView.rightAnchor.constraint(equalTo: puzzleGridView.rightAnchor)
    ]
    
    self.portraitConstraints.append(contentsOf: portraitConstraints)
    self.regularPortraitConstraints.append(contentsOf: portraitConstraints)
    
    portraitConstraints = [
      shareButton.centerYAnchor.constraint(equalTo: centeringView.centerYAnchor),
      shareButton.leftAnchor.constraint(equalTo: centeringView.leftAnchor),
      shareButton.rightAnchor.constraint(equalTo: centeringView.rightAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 30)
    ]
    
    self.portraitConstraints.append(contentsOf: portraitConstraints)
    
    portraitConstraints = [
      shareButton.centerYAnchor.constraint(equalTo: centeringView.centerYAnchor),
      shareButton.leftAnchor.constraint(equalTo: centeringView.leftAnchor),
      shareButton.rightAnchor.constraint(equalTo: centeringView.rightAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 60)
    ]
    
    self.regularPortraitConstraints.append(contentsOf: portraitConstraints)
  }
  
  private func setupLandscapeConstraintsForShareButton() {
    guard let shareButton = shareButton else { fatalError("Share Button is nil") }
    
    var landscapeConstraints = [
      shareButton.bottomAnchor.constraint(equalTo: puzzleGridView.bottomAnchor),
      shareButton.leftAnchor.constraint(equalTo: containerGridView.leftAnchor),
      shareButton.rightAnchor.constraint(equalTo: containerGridView.rightAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 30)
    ]
    
    self.landscapeConstraints.append(contentsOf: landscapeConstraints)
    
    landscapeConstraints = [
      shareButton.bottomAnchor.constraint(equalTo: puzzleGridView.bottomAnchor),
      shareButton.leftAnchor.constraint(equalTo: containerGridView.leftAnchor),
      shareButton.rightAnchor.constraint(equalTo: containerGridView.rightAnchor),
      shareButton.heightAnchor.constraint(equalToConstant: 60)
    ]
    
    self.regularLandscapeConstraints.append(contentsOf: landscapeConstraints)
  }
  
  private func bringPuzzleToFront() {
    bringSubviewToFront(puzzleGridView)
    for piece in puzzlePieceViews {
      bringSubviewToFront(piece)
    }
  }
}

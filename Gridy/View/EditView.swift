//
//  EditView.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol EditViewDelegate: AnyObject {
  func startButtonTouched()
  func quitButtonTouched()
}

class EditView: UIView {
  
  private var imageView: UIImageView!
  private var clearView: UIView!
  private var quitButton: UIButton!
  private var startButton: UIButton!
  private var instructionLabel: UILabel!
  
  private var startButtonTopConstraint: NSLayoutConstraint!
  private var startButtonLeftConstraint: NSLayoutConstraint!
  
  private var instructionLabelTopConstraint: NSLayoutConstraint!
  private var instructionLabelLeftConstraint: NSLayoutConstraint!
  private var instructionLabelWidthConstraint: NSLayoutConstraint!
  private var instructionLabelHeightConstraint: NSLayoutConstraint!
  
  private var quitButtonTopConstraint: NSLayoutConstraint!
  private var quitButtonHeightConstraint: NSLayoutConstraint!
  private var quitButtonWidthConstraint: NSLayoutConstraint!
  
  private var initialUIImageViewCenter: CGPoint?
  
  private var isLandscapeOrientation: Bool {
    guard let superview = self.superview else { return false }
    return superview.bounds.width > superview.bounds.height
  }
  
  weak var delegate: EditViewDelegate?
  var imagesBound: [CGRect]!
  var snapshotBounds: CGRect {
    return self.clearView.bounds
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(image: UIImage) {
    super.init(frame: .zero)
    self.clipsToBounds = true
    self.backgroundColor = UIColor.lightGray
    self.translatesAutoresizingMaskIntoConstraints = false
    
    instantiateSubViews(image: image)
    setupConstraints()
    detectUserActions()
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
  
  func updateLayout() {
    initialUIImageViewCenter = nil
    setupLayer(view: clearView)
    updateStartButtonConstraints()
    updateInstructionsLabelConstraints()
  }
  
  func updateLayoutForIpad() {
    updateInstructionsLabelConstraintsForIpad()
  }
  
  func setupLayoutForIpad() {
    var doubleFontSize = Constant.Font.Size.startButtonLabel * 2
    instructionLabel.font = instructionLabel.font.withSize(doubleFontSize)
    startButton.titleLabel?.font = startButton.titleLabel?.font.withSize(doubleFontSize)
    doubleFontSize = Constant.Font.Size.quitButtonLabel * 2
    quitButton.titleLabel?.font = quitButton.titleLabel?.font.withSize(doubleFontSize)
    
    if quitButtonWidthConstraint != nil && quitButtonHeightConstraint != nil && quitButtonTopConstraint != nil {
      quitButtonWidthConstraint.isActive = false
      quitButtonHeightConstraint.isActive = false
      quitButtonTopConstraint.isActive = false
    }
    
    quitButtonTopConstraint = quitButton.topAnchor.constraint(equalTo: clearView.topAnchor, constant: 16)
    quitButtonHeightConstraint = quitButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Height.quitButton)
    quitButtonWidthConstraint = quitButton.widthAnchor.constraint(equalToConstant: Constant.Layout.Width.quitButton)
    
    quitButtonWidthConstraint.isActive = true
    quitButtonHeightConstraint.isActive = true
    quitButtonTopConstraint.isActive = true
  }
  
  private func setupLayer(view: UIView) {
    let fadingOutAnimation = {
      view.alpha = 0.0
      self.startButton.alpha = 0.0
      self.instructionLabel.alpha = 0.0
      self.quitButton.alpha = 0.0
    }
    
    UIView.animate(withDuration: 0.1, animations: fadingOutAnimation) {
      (done) in
      if done {
        view.layer.mask = self.createMaskLayer()
        
        let fadingInAnimation = {
          view.alpha = 1.0
          self.startButton.alpha = 1.0
          self.instructionLabel.alpha = 1.0
          self.quitButton.alpha = 1.0
        }
        UIView.animate(withDuration: 0.75, animations: fadingInAnimation)
      }
    }
  }
  
  private func createMaskLayer() -> CAShapeLayer {
    guard let superView = self.superview else { return CAShapeLayer()}
    let path = CGMutablePath()
    path.addRect(CGRect(origin: .zero, size: superView.bounds.size))
    
    imagesBound = Position.init(parentView: self).getSquares()
    for square in imagesBound {
      path.addRect(square)
    }
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path
    maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
    
    return maskLayer
  }
  
  private func updateStartButtonConstraints() {
    if startButtonTopConstraint != nil
      && startButtonLeftConstraint != nil {
      startButtonTopConstraint.isActive = false
      startButtonLeftConstraint.isActive = false
    }
    
    let startButtonConstraints = createDynamicConstraints(forStartButton: true)
    startButtonTopConstraint = startButtonConstraints.0
    startButtonLeftConstraint = startButtonConstraints.1
    
    startButtonTopConstraint.isActive = true
    startButtonLeftConstraint.isActive = true
  }
  
  private func updateInstructionsLabelConstraints() {
    if instructionLabelTopConstraint != nil
      && instructionLabelLeftConstraint != nil {
      instructionLabelTopConstraint.isActive = false
      instructionLabelLeftConstraint.isActive = false
    }
    
    let instructionLabelConstraints = createDynamicConstraints(forStartButton: false)
    instructionLabelTopConstraint = instructionLabelConstraints.0
    instructionLabelLeftConstraint = instructionLabelConstraints.1
    
    instructionLabelTopConstraint.isActive = true
    instructionLabelLeftConstraint.isActive = true
  }
  
  private func updateInstructionsLabelConstraintsForIpad() {
    if instructionLabelWidthConstraint != nil && instructionLabelHeightConstraint != nil {
      instructionLabelWidthConstraint.isActive = false
      instructionLabelHeightConstraint.isActive = false
    }
    
    let width = isLandscapeOrientation ? Constant.Layout.Width.instructionLabel : Constant.Layout.Width.instructionLabel * 2
    let height = isLandscapeOrientation ? Constant.Layout.Height.instructionLabel * 2 : Constant.Layout.Height.instructionLabel
    
    instructionLabelWidthConstraint = instructionLabel.widthAnchor.constraint(equalToConstant: width)
    instructionLabelHeightConstraint = instructionLabel.heightAnchor.constraint(equalToConstant: height)
    
    instructionLabelWidthConstraint.isActive = true
    instructionLabelHeightConstraint.isActive = true
  }
  
  private func createDynamicConstraints(forStartButton: Bool) -> (NSLayoutConstraint, NSLayoutConstraint) {
    
    var topConstraint = NSLayoutConstraint()
    var leftConstraint = NSLayoutConstraint()
    
    let view: UIView = forStartButton ? startButton : instructionLabel
    
    let offset = self.calculateOffset(forStartButton: forStartButton)
    
    if isLandscapeOrientation {
      topConstraint = view.centerYAnchor.constraint(equalTo: clearView.centerYAnchor)
      leftConstraint = view.leftAnchor.constraint(equalTo: clearView.leftAnchor, constant: offset)
    } else {
      topConstraint = view.topAnchor.constraint(equalTo: clearView.topAnchor, constant: offset)
      leftConstraint = view.centerXAnchor.constraint(equalTo: clearView.centerXAnchor)
    }
    return (topConstraint, leftConstraint)
  }
  
  private func calculateOffset(forStartButton: Bool) -> CGFloat {
    guard let superview = self.superview else { return 0 }
    let safeArea = (self.superview?.safeAreaInsets)!
    let height = superview.bounds.height - safeArea.top - safeArea.bottom
    let width = superview.bounds.width - safeArea.right - safeArea.left
    
    let short = isLandscapeOrientation ? height : width
    let long = isLandscapeOrientation ? width : height
    
    let viewWidth = Constant.Layout.Width.button
    let viewHeight = Constant.Layout.Height.button
    
    let viewOffset = isLandscapeOrientation ? viewWidth : viewHeight
    
    let sizeTile = short * Constant.Layout.SizeRatio.puzzleGrid / CGFloat(Constant.Tiles.Puzzle.countByRow)
    let allSquareSize = sizeTile * CGFloat(Constant.Tiles.Puzzle.countByRow) + Constant.Tiles.Puzzle.gapLength * 3
    let maxSquare = forStartButton ? ((long - allSquareSize) / 2) + allSquareSize : ((long - allSquareSize) / 2)
    let margin = forStartButton ? (long - maxSquare) / 2 - viewOffset / 2 : (maxSquare) / 2 + viewOffset / 2
    
    let offset = forStartButton ? maxSquare + margin : maxSquare - margin
    
    return offset
  }
  
  private func instantiateSubViews(image: UIImage) {
    instantiateImageView(image: image)
    instantiateClearView()
    instantiateQuitButton()
    instantiateStartButton()
    instantiateInstructionLabel()
  }
  
  private func instantiateImageView(image: UIImage) {
    imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
  }
  
  private func instantiateClearView() {
    clearView = UIView(frame: CGRect())
    clearView.translatesAutoresizingMaskIntoConstraints = false
    clearView.backgroundColor = UIColor.transparent
    clearView.isUserInteractionEnabled = false
  }
  
  private func instantiateQuitButton() {
    quitButton = UIButton(type: .custom)
    quitButton.translatesAutoresizingMaskIntoConstraints = false
    quitButton.setTitle("x", for: .normal)
    quitButton.setTitleColor(UIColor.olsoGray, for: .normal)
    quitButton.titleLabel?.font = UIFont(name: Constant.Font.Name.timeBurner, size: Constant.Font.Size.quitButtonLabel)
  }
  
  private func instantiateStartButton() {
    startButton = UIButton(type: .custom)
    startButton.translatesAutoresizingMaskIntoConstraints = false
    startButton.setTitle("Start", for: .normal)
    startButton.setTitleColor(UIColor.white, for: .normal)
    startButton.backgroundColor = UIColor.vistaBlue
    startButton.titleLabel?.font = UIFont(name: Constant.Font.Name.timeBurner, size: Constant.Font.Size.startButtonLabel)
    startButton.layer.cornerRadius = 10
    startButton.clipsToBounds = true
  }
  
  private func instantiateInstructionLabel() {
    instructionLabel = UILabel()
    instructionLabel.translatesAutoresizingMaskIntoConstraints = false
    instructionLabel.text = "Adjust the puzzle image:\nzoom, rotate, reposition\nDouble tap to reset"
    instructionLabel.textColor = UIColor.olsoGray
    instructionLabel.textAlignment = .center
    instructionLabel.baselineAdjustment = .alignCenters
    instructionLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: Constant.Font.Size.instructionLabel)
    instructionLabel.adjustsFontSizeToFitWidth = true
    instructionLabel.numberOfLines = 0
  }
  
  private func setupConstraints() {
    let safeArea = self.safeAreaLayoutGuide
    // Order important
    setupConstraintsForImageView(safeArea: safeArea)
    setupConstraintsForClearView(safeArea: safeArea)
    // Order not important
    setupConstraintsForStartButton()
    setupConstraintsForQuitButton()
    setupConstraintsForInstructionLabel()
  }
  
  private func setupConstraintsForImageView(safeArea: UILayoutGuide) {
    addSubview(imageView)
    imageView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    imageView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
    imageView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
  }
  
  private func setupConstraintsForClearView(safeArea: UILayoutGuide) {
    addSubview(clearView)
    clearView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    clearView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    clearView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
    clearView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
  }
  
  private func setupConstraintsForQuitButton() {
    addSubview(quitButton)
    quitButton.rightAnchor.constraint(equalTo: clearView.rightAnchor, constant: -16).isActive = true
    
    quitButtonTopConstraint = quitButton.topAnchor.constraint(equalTo: clearView.topAnchor, constant: 0)
    quitButtonHeightConstraint = quitButton.heightAnchor.constraint(equalToConstant: Constant.View.Default.height)
    quitButtonWidthConstraint = quitButton.widthAnchor.constraint(equalToConstant: Constant.View.Default.width)
    
    quitButtonTopConstraint.isActive = true
    quitButtonHeightConstraint.isActive = true
    quitButtonWidthConstraint.isActive = true
  }
  
  private func setupConstraintsForStartButton() {
    addSubview(startButton)
    startButton.widthAnchor.constraint(equalToConstant: Constant.Layout.Width.startButton).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Height.startButton).isActive = true
  }
  
  private func setupConstraintsForInstructionLabel() {
    addSubview(instructionLabel)
    instructionLabelWidthConstraint = instructionLabel.widthAnchor.constraint(equalToConstant: Constant.Layout.Width.instructionLabel)
    instructionLabelHeightConstraint = instructionLabel.heightAnchor.constraint(equalToConstant: Constant.Layout.Height.instructionLabel)
    
    instructionLabelWidthConstraint.isActive = true
    instructionLabelHeightConstraint.isActive = true
  }
  
  private func detectUserActions() {
    quitButton.addTarget(self, action: #selector(quitButtonTouched), for: .touchUpInside)
    startButton.addTarget(self, action: #selector(startButtonTouched), for: .touchUpInside)
    setupGestureRecognizer()
  }
  
  private func setupGestureRecognizer() {
    imageView.isUserInteractionEnabled = true
    
    let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(resetImageFrame))
    doubleTapGestureRecognizer.numberOfTapsRequired = 2
    doubleTapGestureRecognizer.delegate = self
    self.addGestureRecognizer(doubleTapGestureRecognizer)
    
    let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(moveImageView))
    panGestureRecognizer.delegate = self
    imageView.addGestureRecognizer(panGestureRecognizer)
    
    let rotationGestureRecognizer = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateImageView))
    rotationGestureRecognizer.delegate = self
    imageView.addGestureRecognizer(rotationGestureRecognizer)
    
    let pinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(scaleImageView))
    pinchGestureRecognizer.delegate = self
    imageView.addGestureRecognizer(pinchGestureRecognizer)
  }
  
  @objc private func startButtonTouched() {
    delegate?.startButtonTouched()
  }
  
  @objc private func quitButtonTouched() {
    delegate?.quitButtonTouched()
  }
  
  @objc private func resetImageFrame() {
    let animation = {
      if let center = self.initialUIImageViewCenter {
        self.imageView.center = center
      }
      self.imageView.transform = .identity
    }
    
    UIView.animate(withDuration: 1.0,
                   delay: 0.0,
                   usingSpringWithDamping: 0.5,
                   initialSpringVelocity: 0.5,
                   options: [],
                   animations: animation)
  }
  
  @objc private func moveImageView(_ sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    
    if initialUIImageViewCenter == nil {
      initialUIImageViewCenter = imageView.center
    }
    
    let newPoint = CGPoint(x: imageView.center.x + translation.x,
                           y: imageView.center.y + translation.y)
    imageView.center = newPoint
    sender.setTranslation(CGPoint.zero, in: self)
  }
  
  @objc private func rotateImageView(_ sender: UIRotationGestureRecognizer) {
    imageView.transform = imageView.transform.rotated(by: sender.rotation)
    sender.rotation = 0
  }
  
  @objc private func scaleImageView(_ sender: UIPinchGestureRecognizer) {
    imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
    sender.scale = 1
  }
}

extension EditView: UIGestureRecognizerDelegate {
  // Delegate method: UIGestureRecognizerDelegate
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer.view != imageView {
      return false
    }
    
    if otherGestureRecognizer.view != imageView {
      return false
    }
    
    if gestureRecognizer is UITapGestureRecognizer
      || otherGestureRecognizer is UITapGestureRecognizer
      || gestureRecognizer is UIPanGestureRecognizer
      || otherGestureRecognizer is UIPanGestureRecognizer {
      return false
    }
    return true
  }
}

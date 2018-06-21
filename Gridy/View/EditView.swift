//
//  EditView.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol EditViewDelegate {
  func startPuzzle()
  func goBackMainMenu()
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
  
  private var initialUIImageViewCenter: CGPoint?
  
  private var isLandscapeOrientation: Bool {
    return UIScreen.main.bounds.width > UIScreen.main.bounds.height
  }
  
  var delegate: EditViewDelegate!
  var imagesBound: [CGRect]!
  var snapshotBounds: CGRect {
    return self.clearView.bounds
  }
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  init(image: UIImage) {
    super.init(frame: UIScreen.main.bounds)
    self.clipsToBounds = true
    self.backgroundColor = UIColor.lightGray
    self.translatesAutoresizingMaskIntoConstraints = false
    
    instantiateSubViews(image: image)
    layOutSubviews()
    detectUserActions()
  }
  
  func setupIn(parentView view: UIView) {
    view.backgroundColor = UIColor.white
    view.addSubview(self)
    let safeArea = view.safeAreaLayoutGuide
    self.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
    self.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
    self.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
    self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
  }
  
  private func setupOverlay(view: UIView) {
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
        UIView.animate(withDuration: 1, animations: fadingInAnimation)
      }
    }
  }
  
  private func createMaskLayer() -> CAShapeLayer {
    let path = CGMutablePath()
    path.addRect(CGRect(origin: .zero, size: UIScreen.main.bounds.size))
    
    imagesBound = Position.init(parentView: self, isEditingView: true).getSquares()
    for square in imagesBound {
      path.addRect(square)
    }
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path
    maskLayer.fillRule = kCAFillRuleEvenOdd
    
    return maskLayer
  }
  
  private func updateLayOutConstraints() {
    updateStartButtonConstraints()
    updateInstructionsLabelConstraints()
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
  }
  
  private func createDynamicConstraints(forStartButton: Bool) -> (NSLayoutConstraint, NSLayoutConstraint) {
    
    var topConstraint = NSLayoutConstraint()
    var leftConstraint = NSLayoutConstraint()
    
    let view = forStartButton ? startButton : instructionLabel
    
    let offset = self.calculateOffset(forStartButton: forStartButton)
    
    if isLandscapeOrientation {
      topConstraint = view.centerYAnchor.constraint(equalTo: clearView.centerYAnchor)
      topConstraint.isActive = true
      leftConstraint = view.leftAnchor.constraint(equalTo: clearView.leftAnchor, constant: offset)
      leftConstraint.isActive = true
    } else {
      topConstraint = view.topAnchor.constraint(equalTo: clearView.topAnchor, constant: offset)
      topConstraint.isActive = true
      leftConstraint = view.centerXAnchor.constraint(equalTo: clearView.centerXAnchor)
      leftConstraint.isActive = true
    }
    
    return (topConstraint, leftConstraint)
  }
  
  private func calculateOffset(forStartButton: Bool) -> CGFloat {
    let safeArea = (self.superview?.safeAreaInsets)!
    let height = UIScreen.main.bounds.height - safeArea.top - safeArea.bottom
    let width = UIScreen.main.bounds.width - safeArea.right - safeArea.left
    
    let short = isLandscapeOrientation ? height : width
    let long = isLandscapeOrientation ? width : height
    let viewOffset = isLandscapeOrientation ? Constant.Layout.Width.button : Constant.Layout.Height.button
    
    let size = short * 0.9 / 4
    let allSquareSize = size * 4 + 3
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
    clearView.backgroundColor = GridyColor.transparent
    clearView.isUserInteractionEnabled = false
  }
  
  private func instantiateQuitButton() {
    quitButton = UIButton(type: .custom)
    quitButton.translatesAutoresizingMaskIntoConstraints = false
    quitButton.setTitle("X", for: .normal)
    quitButton.setTitleColor(GridyColor.olsoGray, for: .normal)
    quitButton.titleLabel?.font = UIFont(name: Constant.Font.Name.timeBurner, size: Constant.Font.size.quitButtonLabel)
  }
  
  private func instantiateStartButton() {
    startButton = UIButton(type: .custom)
    startButton.translatesAutoresizingMaskIntoConstraints = false
    startButton.setTitle("Start", for: .normal)
    startButton.setTitleColor(UIColor.white, for: .normal)
    startButton.backgroundColor = GridyColor.vistaBlue
    startButton.titleLabel?.font = UIFont(name: Constant.Font.Name.timeBurner, size: Constant.Font.size.choiceLabel)
    startButton.layer.cornerRadius = 10
    startButton.clipsToBounds = true
  }
  
  private func instantiateInstructionLabel() {
    instructionLabel = UILabel()
    instructionLabel.translatesAutoresizingMaskIntoConstraints = false
    instructionLabel.text = "Adjust the puzzle image:\nzoom, rotate, reposition\nDouble tap to reset"
    instructionLabel.textColor = GridyColor.olsoGray
    instructionLabel.textAlignment = .center
    instructionLabel.baselineAdjustment = .alignCenters
    instructionLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: Constant.Font.size.choiceLabel)
    instructionLabel.adjustsFontSizeToFitWidth = true
    instructionLabel.numberOfLines = 0
  }
  
  private func layOutSubviews() {
    let safeArea = self.safeAreaLayoutGuide
    // Order important
    layOutImageView(safeArea: safeArea)
    layOutClearView(safeArea: safeArea)
    // Order not important
    layOutStartButton()
    layOutQuitButton()
    layOutInstructionLabel()
  }
  
  private func layOutImageView(safeArea: UILayoutGuide) {
    addSubview(imageView)
    imageView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    imageView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
    imageView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
  }
  
  private func layOutClearView(safeArea: UILayoutGuide) {
    addSubview(clearView)
    clearView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    clearView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    clearView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
    clearView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
  }
  
  private func layOutQuitButton() {
    addSubview(quitButton)
    quitButton.topAnchor.constraint(equalTo: clearView.topAnchor, constant: 0).isActive = true
    quitButton.rightAnchor.constraint(equalTo: clearView.rightAnchor, constant: -16).isActive = true
  }
  
  private func layOutStartButton() {
    addSubview(startButton)
    startButton.widthAnchor.constraint(equalToConstant: Constant.Layout.Width.button).isActive = true
    startButton.heightAnchor.constraint(equalToConstant: Constant.Layout.Height.button).isActive = true
  }
  
  private func layOutInstructionLabel() {
    addSubview(instructionLabel)
    instructionLabel.widthAnchor.constraint(equalToConstant: Constant.Layout.Width.button).isActive = true
    instructionLabel.heightAnchor.constraint(equalToConstant: Constant.Layout.Height.button).isActive = true
  }
  
  private func detectUserActions() {
    quitButton.addTarget(self, action: #selector(pressedQuitButton), for: .touchUpInside)
    startButton.addTarget(self, action: #selector(pressedStartButton), for: .touchUpInside)
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
  
  @objc func pressedStartButton() {
    delegate.startPuzzle()
  }
  
  @objc private func pressedQuitButton() {
    delegate.goBackMainMenu()
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
  
  // Delegate method: UIGestureRecognizerDelegate
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    var beReceived = true
    if let view = touch.view {
      beReceived = view.isDescendant(of: self) ? true : false
    }
    return beReceived
  }
  
  // Delegate method: UITraitEnvironment
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    initialUIImageViewCenter = nil
    setupOverlay(view:clearView)
    updateLayOutConstraints()
  }
}

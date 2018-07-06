  //
//  IntroView.swift
//  Gridy
//
//  Created by Spencer Forrest on 18/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol IntroViewDelegate: AnyObject {
  func takeRandomImage()
  func takeCameraImage()
  func takePhotoLibraryImage()
}
  
class IntroView: UIView {
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  var titleLabel: UILabel!
  var commentLabel: UILabel!
  private var choiceLabel: UILabel!
  
  private var randomButton: Button!
  private var photosButton: Button!
  private var cameraButton: Button!
  
  private var buttonStackView: UIStackView!
  private var verticalStackView: UIStackView!
  private var horizontalStackView: UIStackView!
  
  private var titleLabelHeightConstraint: NSLayoutConstraint!
  private var commentLabelHeightConstraint: NSLayoutConstraint!
  private var buttonStackViewHeightConstraint: NSLayoutConstraint!
  private var horizontalStackViewSpacing: NSLayoutConstraint!
  
  private var verticalStackViewSpacing: NSLayoutConstraint!
  
  weak var delegate: IntroViewDelegate?
  
  init() {
    super.init(frame: .zero)
    
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white
    
    instantiateSubviews()
    setupConstraint()
    detectUserActions()
  }
  
  func setup(parentView view: UIView) {
    view.addSubview(self)
    self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  private func updateStackViewConstraint(forIpad: Bool) {
    if buttonStackViewHeightConstraint == nil {
      let size = forIpad ? Constant.Layout.Height.buttonStackView * 1.5 + 30 : Constant.Layout.Height.buttonStackView
      buttonStackViewHeightConstraint = buttonStackView.heightAnchor.constraint(equalToConstant: size)
      buttonStackViewHeightConstraint.isActive = true
      
      let horizontalSpacing = forIpad ? Constant.Layout.Spacing.buttonStackViewiPad * 1.5 : Constant.Layout.Spacing.buttonStackViewiPhone
      self.horizontalStackView.spacing = horizontalSpacing
      let verticalSpacing: CGFloat = forIpad ? 30 : 0
      self.verticalStackView.spacing = verticalSpacing
      if forIpad { choiceLabel.font = choiceLabel.font.withSize(30) }
    }
  }
  
  private func updateButtonConstraints(forIpad: Bool) {
    randomButton.setupSizeConstraint(forIpad: forIpad)
    cameraButton.setupSizeConstraint(forIpad: forIpad)
    photosButton.setupSizeConstraint(forIpad: forIpad)
  }
  
  private func updateTitleLabelConstraint() {
    guard let superview = self.superview else { return }
    
    if let titleLabelHeightConstraint = self.titleLabelHeightConstraint {
      titleLabelHeightConstraint.isActive = false
    }
    
    let height = superview.bounds.height * Constant.Layout.HeightRatio.titleLabel
    self.titleLabelHeightConstraint = self.titleLabel.heightAnchor.constraint(equalToConstant: height)
    self.titleLabelHeightConstraint.isActive = true
    self.titleLabel.font = self.titleLabel.font.withSize(height * Constant.Font.sizeRatio.titleLabel)
  }
  
  private func updateCommentLabelConstraint() {
    if let commentLabelHeightCosntraint = self.commentLabelHeightConstraint {
      commentLabelHeightCosntraint.isActive = false
    }
    
    let height = self.titleLabel.font.pointSize * Constant.Layout.HeightRatio.commentLabel
    self.commentLabelHeightConstraint = self.commentLabel.heightAnchor.constraint(equalToConstant: height)
    self.commentLabelHeightConstraint.isActive = true
    self.commentLabel.font = self.commentLabel.font.withSize(height * Constant.Font.sizeRatio.commentLabel)
  }
  
  private func detectUserActions() {
    randomButton.addTarget(self, action: #selector(pushedRandomButton), for: UIControlEvents.touchUpInside)
    cameraButton.addTarget(self, action: #selector(pushedCameraButton), for: UIControlEvents.touchUpInside)
    photosButton.addTarget(self, action: #selector(pushedPotosButton), for: UIControlEvents.touchUpInside)
  }
  
  @objc private func pushedRandomButton() {
    delegate?.takeRandomImage()
  }
  
  @objc private func pushedCameraButton() {
    delegate?.takeCameraImage()
  }
  
  @objc private func pushedPotosButton() {
    delegate?.takePhotoLibraryImage()
  }
  
  private func setupConstraint() {
    let safeArea = self.safeAreaLayoutGuide
    setupTitleLabelConstraints(safeArea: safeArea)
    setupCommentLabelConstraints(safeArea: safeArea)
    setupButtonStackViewConstraints(safeArea: safeArea)
  }
  
  private func setupTitleLabelConstraints(safeArea: UILayoutGuide) {
    self.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.Layout.Padding.titleLabel).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.Layout.Padding.titleLabel).isActive = true
  }
  
  private func setupCommentLabelConstraints(safeArea: UILayoutGuide) {
    self.addSubview(commentLabel)
    commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
    commentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0).isActive = true
    commentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
  }
  
  private func setupButtonStackViewConstraints(safeArea: UILayoutGuide) {
    let containerView = createContainerView()
    containerView.addSubview(buttonStackView)
    buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    buttonStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    
    self.addSubview(containerView)
    containerView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 0).isActive = true
    containerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
    containerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
    containerView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
  }
  
  private func createContainerView() -> UIView {
    let containerView = UIView.init()
    containerView.backgroundColor = UIColor.clear
    containerView.translatesAutoresizingMaskIntoConstraints = false
    return containerView
  }
  
  private func instantiateSubviews() {
    instantiateButtons()
    instantiateLabels()
    instantiateStackViews()
  }
  
  private func instantiateButtons() {
    randomButton = Button(imageName: Constant.ImageName.random)
    photosButton = Button(imageName: Constant.ImageName.photos)
    cameraButton = Button(imageName: Constant.ImageName.camera)
  }
  
  private func instantiateLabels() {
    titleLabel = Label(text: Constant.String.title, fontSize: Constant.Font.size.titleLabel, useCustomFont: true)
    commentLabel = Label(text: Constant.String.comment, fontSize: Constant.Font.size.commentLabel)
    choiceLabel = Label(text: Constant.String.choice, fontSize: Constant.Font.size.choiceLabel)
  }
  
  private func instantiateStackViews() {
    verticalStackView = UIStackView.init(arrangedSubviews: [randomButton!, choiceLabel!])
    horizontalStackView = UIStackView.init(arrangedSubviews: [cameraButton!, photosButton!])
    buttonStackView = UIStackView.init(arrangedSubviews: [verticalStackView!, horizontalStackView!])
    
    self.setup(stackView: horizontalStackView, axis: .horizontal)
    self.setup(stackView: verticalStackView)
    self.setup(stackView: buttonStackView)
  }
  
  private func setup(stackView: UIStackView, axis: UILayoutConstraintAxis = .vertical) {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.alignment = .center
    stackView.distribution = .fill
  }
}

extension IntroView {
  // Delegate method: UITraitEnvironment
  // UIView and UIViewController conform to it
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let horizontaSizeClassChanged = previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
    let verticalSizeClassChanged = previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass
    
    if verticalSizeClassChanged || horizontaSizeClassChanged {
      let sizeClass = (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
      let iPad = (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular)
      let forIpad = sizeClass == iPad
      
      updateStackViewConstraint(forIpad: forIpad)
      updateButtonConstraints(forIpad: forIpad)
      updateTitleLabelConstraint()
      updateCommentLabelConstraint()
    }
  }
}

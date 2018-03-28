  //
//  IntroView.swift
//  Gridy
//
//  Created by Spencer Forrest on 18/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol IntroViewDelegate {
  func takeRandomImage() -> UIImage?
  func takeCameraImage() -> UIImage?
  func takePhotoLibraryImage() -> UIImage?
}

class IntroView: UIView {
  
  required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  var titleLabel: UILabel!
  var commentLabel: UILabel!
  private var choiceLabel: UILabel!
  
  private let title = "Gridy"
  private let comment = "Challenge yourself with a photo puzzle"
  private let choice = "- OR load your own -"
  
  private let helveticaNeueFontName = "Helvetica Neue"
  private let timeBurnerFontName = "TimeBurner"
  
  private var randomButton: UIButton!
  private var photosButton: UIButton!
  private var cameraButton: UIButton!
  
  private let nameRandomImage = "Random"
  private let namePhotosImage = "Photos"
  private let nameCameraImage = "Camera"
  
  private var buttonStackView: UIStackView!
  private var verticalStackView: UIStackView!
  var horizontalStackView: UIStackView!
  
  var titleLabelHeightConstraint: NSLayoutConstraint!
  var commentLabelHeightCosntraint: NSLayoutConstraint!
  
  var delegate: IntroViewDelegate!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white
    
    setupStackViews()
    setupLayout()
    setupActions()
  }
  
  // Delegate method: UITraitEnvironment
  // UIView and UIViewController conform to it
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let sizeClass = (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
    let iPads = (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular)
    
    if sizeClass == iPads {
      self.horizontalStackView.spacing = 200
    } else {
      self.horizontalStackView.spacing = 50
    }
    
    if let titleLabelHeightConstraint = self.titleLabelHeightConstraint {
      titleLabelHeightConstraint.isActive = false
    }
    
    var height = self.bounds.height / 4
    self.titleLabelHeightConstraint = self.titleLabel.heightAnchor.constraint(equalToConstant: height)
    self.titleLabelHeightConstraint.isActive = true
    self.titleLabel.font = self.titleLabel.font.withSize(height * 0.9)
    
    if let commentLabelHeightCosntraint = self.commentLabelHeightCosntraint {
      commentLabelHeightCosntraint.isActive = false
    }
    
    height = self.titleLabel.font.pointSize / 5
    self.commentLabelHeightCosntraint = self.commentLabel.heightAnchor.constraint(equalToConstant: height)
    self.commentLabelHeightCosntraint.isActive = true
    self.commentLabel.font = self.commentLabel.font.withSize(height * 0.8)
  }
  
  private func setupActions() {
    randomButton.addTarget(self, action: #selector(pushedRandomButton), for: UIControlEvents.touchUpInside)
    cameraButton.addTarget(self, action: #selector(pushedCameraButton), for: UIControlEvents.touchUpInside)
    photosButton.addTarget(self, action: #selector(pushedPotosButton), for: UIControlEvents.touchUpInside)
  }
  
  @objc private func pushedRandomButton() {
    _ = delegate.takeRandomImage()
  }
  
  @objc private func pushedCameraButton() {
    _ = delegate.takeCameraImage()
  }
  
  @objc private func pushedPotosButton() {
    _ = delegate.takePhotoLibraryImage()
  }
  
  /// To be called on "ViewDidLoad" in the viewController
  private func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    
    self.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    
    self.addSubview(commentLabel)
    commentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
    commentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0).isActive = true
    commentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
    
    let containerView = UIView.init()
    containerView.backgroundColor = UIColor.clear
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(buttonStackView)
    buttonStackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    buttonStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    
    self.addSubview(containerView)
    containerView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 0).isActive = true
    containerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
    containerView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0).isActive = true
    containerView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0).isActive = true
  }
  
  private func setupStackViews() {
    self.instantiateSubviews()
    self.instantiateStackViews()
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
  
  func instantiateStackViews() {
    verticalStackView = UIStackView.init(arrangedSubviews: [randomButton!, choiceLabel!])
    horizontalStackView = UIStackView.init(arrangedSubviews: [cameraButton!, photosButton!])
    buttonStackView = UIStackView.init(arrangedSubviews: [verticalStackView!, horizontalStackView!])
  }
  
  /// Call before instantiating the stackViews or app will crash
  private func instantiateSubviews() {
    randomButton = createButton(imageName: nameRandomImage)
    photosButton = createButton(imageName: namePhotosImage)
    cameraButton = createButton(imageName: nameCameraImage)
    titleLabel = createLabel(text: title, fontName: timeBurnerFontName, fontSize: 1, textColor: GridyColor.vistaBlue)
    commentLabel = createLabel(text: comment, fontName: helveticaNeueFontName, fontSize: 1)
    choiceLabel = createLabel(text: choice, fontName: helveticaNeueFontName, fontSize: 17, textColor: GridyColor.olsoGray)
  }
  
  private func createButton(imageName: String) -> UIButton {
    let image = UIImage.init(named: imageName)
    let button = UIButton.init(type: .custom)
    button.setImage(image, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.layer.masksToBounds = true
    button.isUserInteractionEnabled = true
    
    button.backgroundColor = GridyColor.janna
    
    button.widthAnchor.constraint(equalToConstant: 115).isActive = true
    button.heightAnchor.constraint(equalToConstant: 88).isActive = true
    
    return button
  }
  
  private func createLabel(text: String?,
                           fontName: String,
                           fontSize: CGFloat,
                           textColor: UIColor = UIColor.black) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.numberOfLines = 1
    label.baselineAdjustment = .alignCenters
    label.textAlignment = .center
    label.textColor = textColor
    
    let font = UIFont.init(name: fontName, size: fontSize)!
    label.font = font
    label.minimumScaleFactor = 0.1
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }
}

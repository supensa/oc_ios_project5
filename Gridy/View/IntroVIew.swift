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
  
  private var titleLabel: UILabel!
  private var commentLabel: UILabel!
  private var choiceLabel: UILabel!
  
  private let title = "Gridy"
  private let comment = "Challenge yourself with a photo puzzle"
  private let choice = "- OR load your own -"
  
  private let helveticaNeueFontName = "Helvetica Neue"
  private let timeBurnerFontName = "TimeBurner"
  
  private var randomImageView: UIImageView!
  private var photosImageView: UIImageView!
  private var cameraImageView: UIImageView!
  private var choiceImageView: UIImageView!
  
  private let nameRandomImage = "Random"
  private let namePhotosImage = "Photos"
  private let nameCameraImage = "Camera"
  
  private var mainStackView: UIStackView!
  private var firstStackView: UIStackView!
  private var secondStackView: UIStackView!
  private var horizontalStackView: UIStackView!
  
  var delegate: IntroViewDelegate!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = UIColor.white
    
    setupStackViews()
    setupLayout()
    setupGestureRecognizers()
  }
  
  private func setupGestureRecognizers() {
    
  }
  
  private func setupLayout() {
    self.addSubview(mainStackView)
    mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    mainStackView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
    mainStackView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
    mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 16).isActive = true
  }
  
  private func setupStackViews() {
    self.instantiateSubviews()
    self.instantiateStackViews()
    self.setup(stackView: horizontalStackView, axis: .horizontal)
    self.setup(stackView: secondStackView)
    self.setup(stackView: firstStackView)
    self.setup(stackView: mainStackView)
  }
  
  private func setup(stackView: UIStackView, axis: UILayoutConstraintAxis = .vertical) {
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
  }
  
  func instantiateStackViews() {
    horizontalStackView = UIStackView.init(arrangedSubviews: [cameraImageView!, photosImageView!])
    secondStackView = UIStackView.init(arrangedSubviews: [randomImageView!, choiceLabel!, horizontalStackView!])
    firstStackView = UIStackView.init(arrangedSubviews: [titleLabel!, commentLabel!])
    mainStackView = UIStackView.init(arrangedSubviews: [firstStackView!, secondStackView!])
  }
  
  /// Call before instantiating the stackViews or app will crash
  private func instantiateSubviews() {
    randomImageView = createImageView(imageName: nameRandomImage)
    photosImageView = createImageView(imageName: namePhotosImage)
    cameraImageView = createImageView(imageName: nameCameraImage)
    titleLabel = createLabel(text: title, fontName: timeBurnerFontName, fontSize: 100, textColor: GridyColor.vistaBlue)
    commentLabel = createLabel(text: comment, fontName: helveticaNeueFontName, fontSize: 30)
    choiceLabel = createLabel(text: choice, fontName: helveticaNeueFontName, fontSize: 20, textColor: GridyColor.olsoGray)
  }
  
  private func createImageView(imageName: String, aspectRation: Bool = false) -> UIImageView {
    let image = UIImage.init(named: imageName)
    let imageView = UIImageView.init(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = true
    
    return imageView
  }
  
  private func createLabel(text: String?, fontName: String, fontSize: CGFloat, textColor: UIColor = UIColor.black) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = text
    label.textAlignment = .center
    label.textColor = textColor
    label.font = UIFont.init(name: fontName, size: fontSize)
    label.adjustsFontSizeToFitWidth = true
    
    return label
  }
}

//
//  EditViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
  var image: UIImage!
  var wholeImage: UIImage?
  var editView: EditView!
  
  override func viewDidLoad() {
    editView = EditView.init(image: image!)
    editView.delegate = self
    editView.setup(parentView: self.view)
  }
  
  // Update Layout for iPad if needed
  override func viewWillLayoutSubviews() {
    editView.updateLayout()
    let sizeClass = (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
    let iPad = (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular)
    if sizeClass == iPad {
      editView.updateLayoutForIpad()
    }
  }
  
  // Setup layout and font for iPad if needed
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let horizontaSizeClassChanged = previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
    let verticalSizeClassChanged = previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass
    
    if verticalSizeClassChanged || horizontaSizeClassChanged {
      let sizeClass = (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
      let iPad = (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular)
      if iPad == sizeClass {
        editView.setupLayoutForIpad()
      }
    }
  }
}

extension EditViewController: EditViewDelegate {
  // Delegate method: EditViewDelegate
  /// Dismiss actual view controller
  func quitButtonTouched() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // Delegate method: EditViewDelegate
  /// Get screenshots and present PlayViewController
  func startButtonTouched() {
    let playViewController = PlayViewController()
    playViewController.imagesWithInitialPosition = self.getSnapshots()
    playViewController.hintImage = self.getHintImage()
    playViewController.modalPresentationStyle = .fullScreen
    playViewController.modalTransitionStyle = .coverVertical
    self.present(playViewController, animated: true)
  }
  
  /// Take a snapshot of all the images in order
  ///
  /// - Returns: Hint Image
  private func getHintImage() -> UIImage {
    let rectangle = calculateBoundHintImage()
    let image = cropImage(image: wholeImage!, rectangle: rectangle)
    return image
  }
  
  /// Calculate the frame of the hint image
  ///
  /// - Returns: Hint image frame
  private func calculateBoundHintImage() -> CGRect {
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    // There are 16 squares 4 per row and 4 per columns
    for index in 0...3 {
      let bound = editView.imagesBound[index]
      height += bound.height
      width += bound.width
    }
    
    let size = CGSize(width: width, height: height)
    let origin = editView.imagesBound[0].origin
    let bound = CGRect(origin: origin, size: size)
    
    return bound
  }
  
  /// Get images of all the squares
  ///
  /// - Returns: array of snapshots
  private func getSnapshots() -> [Image] {
    guard let imagesBound = editView.imagesBound  else { return [Image]() }
    var images = [Image]()
    wholeImage = snapshotWholeScreen()
    let max = imagesBound.count - 1
    for index in 0...max {
      let bound = imagesBound[index]
      let image = cropImage(image: wholeImage!, rectangle: bound, id: index)
      images.append(image)
    }
    return images
  }
  
  /// Take a snapshot of the whole screen
  ///
  /// - Returns: UIImage of the main view
  private func snapshotWholeScreen() -> UIImage {
    let bounds = self.editView.bounds
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    self.editView.drawHierarchy(in: bounds, afterScreenUpdates: true)
    let snapshot = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return snapshot
  }
  
  /// Create a "Image" with id by croping a UIImage
  ///
  /// - Parameters:
  ///   - image: Image to crop
  ///   - rectangle: Frame to crop
  ///   - id: Initial position
  /// - Returns: Image with id
  private func cropImage(image: UIImage, rectangle: CGRect, id: Int) -> Image {
    let uiimage = cropImage(image: image, rectangle: rectangle)
    return Image(image: uiimage, id: id)
  }
  
  /// Create a cropped UIImage
  ///
  /// - Parameters:
  ///   - image: Full size image
  ///   - rectangle: Frame to crop
  /// - Returns: Cropped UIImage
  private func cropImage(image: UIImage, rectangle: CGRect) -> UIImage {
    let scale: CGFloat = image.scale
    let scaledRect = CGRect(x: rectangle.origin.x * scale,
                            y: rectangle.origin.y * scale,
                            width: rectangle.size.width * scale,
                            height: rectangle.size.height * scale)
    let cgImage = image.cgImage?.cropping(to: scaledRect)
    let uiimage = UIImage(cgImage: cgImage!, scale: scale, orientation: .up)
    return uiimage
  }
}

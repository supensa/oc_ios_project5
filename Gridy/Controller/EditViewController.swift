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
  var imagesBound: [CGRect]!
  var wholeImage: UIImage?
  var editView: EditView!
  
  override func viewDidLoad() {
    editView = EditView.init(image: image!)
    editView.delegate = self
    editView.setup(parentView: self.view)
  }
  
  override func viewWillLayoutSubviews() {
    editView.updateLayout()
    let sizeClass = (self.traitCollection.horizontalSizeClass, self.traitCollection.verticalSizeClass)
    let iPad = (UIUserInterfaceSizeClass.regular, UIUserInterfaceSizeClass.regular)
    if sizeClass == iPad {
      editView.updateLayoutForIpad()
    }
  }
  
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
  func quitButtonTouched() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // Delegate method: EditViewDelegate
  func startButtonTouched() {
    self.imagesBound = editView.imagesBound
    let playViewController = PlayViewController()
    playViewController.images = self.getSnapshots()
    playViewController.hintImage = self.getHintImage()
    self.present(playViewController, animated: true)
  }
  
  private func getHintImage() -> UIImage {
    let rectangle = calculateBoundHintImage()
    let image = cropImage(image: wholeImage!, rectangle: rectangle)
    return image
  }
  
  func calculateBoundHintImage() -> CGRect {
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    // There are 16 squares 4 per row and 4 per columns
    for index in 0...3 {
      let bound = imagesBound[index]
      height += bound.height
      width += bound.width
    }
    
    let size = CGSize(width: width, height: height)
    let origin = imagesBound[0].origin
    let bound = CGRect(origin: origin, size: size)
    
    return bound
  }
  
  private func getSnapshots() -> [Image] {
    var images = [Image]()
    if let imagesBound = imagesBound {
      wholeImage = snapshotWholeScreen()
      let max = imagesBound.count - 1
      for index in 0...max {
        let bound = imagesBound[index]
        let image = cropImage(image: wholeImage!, rectangle: bound, id: index)
        images.append(image)
      }
    }
    return images
  }
  
  private func snapshotWholeScreen() -> UIImage {
    let bounds = self.editView.snapshotBounds
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    self.editView.drawHierarchy(in: bounds, afterScreenUpdates: true)
    let snapshot = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return snapshot
  }
  
  private func cropImage(image: UIImage, rectangle: CGRect, id: Int) -> Image {
    let uiimage = cropImage(image: image, rectangle: rectangle)
    return Image(image: uiimage, id: id)
  }
  
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

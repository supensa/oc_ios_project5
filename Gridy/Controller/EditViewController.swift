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
  weak var editView: EditView!
  
  override func viewDidLoad() {
    editView = EditView.init(image: image!)
    editView.delegate = self
    editView.setupIn(parentView: self.view)
  }
}

extension EditViewController: EditViewDelegate {
  // Delegate method: EditViewDelegate
  func goBackMainMenu() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // Delegate method: EditViewDelegate
  func startPuzzle() {
    self.imagesBound = editView.imagesBound
    
    let playViewController = PlayViewController()
    playViewController.images = getSnapshots()
    self.present(playViewController, animated: true)
  }
  
  private func getSnapshots() -> [Image] {
    var images = [Image]()
    if let imagesBound = imagesBound {
      let wholeImage = snapshotWholeScreen()
      let max = imagesBound.count - 1
      for index in 0...max {
        let bound = imagesBound[index]
        let image = cropImage(image: wholeImage, rectangle: bound, position: index)
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
  
  private func cropImage(image: UIImage, rectangle: CGRect, position: Int) -> Image {
    let scale = image.scale
    let scaledRect = CGRect(x: rectangle.origin.x * scale,
                            y: rectangle.origin.y * scale,
                            width: rectangle.size.width * scale,
                            height: rectangle.size.height * scale)
    let cgImage = image.cgImage?.cropping(to: scaledRect)
    let uiimage = UIImage(cgImage: cgImage!, scale: scale, orientation: .up)
    return Image(image: uiimage, position: position)
  }
}

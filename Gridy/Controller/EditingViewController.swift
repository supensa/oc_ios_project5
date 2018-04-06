//
//  EditingViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 28/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {
  var image: UIImage!
  var imagesBound: [CGRect]!
  weak var editingView: EditingView!
  
  override func viewDidLoad() {
    editingView = EditingView.init(image: image!)
    editingView.delegate = self
    editingView.setupIn(parentView: self.view)

  }
}

extension EditingViewController: EditingViewDelegate, PlayViewControllerDelegate {
  // Delegate method: EditingViewDelegate
  func startPuzzle() {
    self.imagesBound = editingView.imagesBound
    
    let playViewController = PlayViewController()
    playViewController.delegate = self
    playViewController.images = getSnapshots()
    self.present(playViewController, animated: true)
  }
  
  func getSnapshots() -> [UIImage] {
    var images = [UIImage]()
    if let imagesBound = imagesBound {
      let wholeImage = snapshotWholeScreen()
      for imageBound in imagesBound {
        let image = cropImage(image: wholeImage, rectangle: imageBound)
        images.append(image)
      }
    }
    return images
  }
  
  /// Snapshot the whole screen
  ///
  /// - Returns: image of the current screen
   private func snapshotWholeScreen() -> UIImage {
    let bounds = self.editingView.snapshotBounds
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    self.editingView.drawHierarchy(in: bounds, afterScreenUpdates: true)
    let snapshot = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return snapshot
  }
  
  private func cropImage(image: UIImage, rectangle: CGRect) -> UIImage {
    let scale = image.scale
    let scaledRect = CGRect(x: rectangle.origin.x * scale,
                            y: rectangle.origin.y * scale,
                            width: rectangle.size.width * scale,
                            height: rectangle.size.height * scale)
    let cgImage = image.cgImage?.cropping(to: scaledRect)
    return UIImage(cgImage: cgImage!, scale: scale, orientation: .up)
  }
  
  // Delegate method: EditingViewDelegate
  func goBackMainMenu() {
    self.dismiss(animated: true, completion: nil)
  }
  
  // Delegate method: PlayViewControllerDelegate
  func dismissParentViewController() {
//    self.presentingViewController?.dismiss(animated: true, completion: nil)
    dismiss(animated: true, completion: nil)
  }
}

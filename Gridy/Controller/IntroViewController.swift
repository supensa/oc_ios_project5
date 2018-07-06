//
//  IntroViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 17/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class IntroViewController: UIViewController {
  override func viewDidLoad() {
    let introView =  IntroView.init()
    introView.delegate = self
    introView.setup(parentView: self.view)
  }
}

extension IntroViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, IntroViewDelegate {
  // Delegate Function: UIImagePickerControllerDelegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    
    var image: UIImage?
    
    if picker.allowsEditing {
      image = info[UIImagePickerControllerEditedImage] as? UIImage
    } else {
      image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    if let image = image {
      let editingViewController = EditViewController()
      editingViewController.image = image
      self.present(editingViewController, animated: true, completion: nil)
    }
  }
  
  // Delegate Function: UIImagePickerControllerDelegate
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  // Delegate method: IntroViewDelegate
  func takeRandomImage() {
    let random = Int.random(min: 0, max: 4)
    if let image = UIImage(named: Constant.ImageName.image + "\(random)") {
      let editingViewController = EditViewController()
      editingViewController.image = image
      self.present(editingViewController, animated: true, completion: nil)
    }
  }
  
  // Delegate method: IntroViewDelegate
  func takeCameraImage() {
    let sourceType = UIImagePickerControllerSourceType.camera
    displayMediaPicker(sourceType: sourceType)
  }
  
  // Delegate method: IntroViewDelegate
  func takePhotoLibraryImage() {
    let sourceType = UIImagePickerControllerSourceType.photoLibrary
    displayMediaPicker(sourceType: sourceType)
  }
  
  func displayMediaPicker(sourceType: UIImagePickerControllerSourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let usingCamera = sourceType == .camera
      let media = usingCamera ? "camera" : "photos"
      let noPermissionMessage = "Looks like Gridy don't have access to your \(media):( Please use Setting app on your device to permit Gridy access to your \(media)"
      
      if usingCamera {
        actionAccordingTo(status: AVCaptureDevice.authorizationStatus(for: AVMediaType.video), sourceType: sourceType, noPermissionMessage: noPermissionMessage)
      } else {
        actionAccordingTo(status: PHPhotoLibrary.authorizationStatus(), sourceType: sourceType, noPermissionMessage: noPermissionMessage)
      }
    } else {
      troubleAlert(message: "Sincere apologies, it looks like we can't access your photo library at this time")
    }
  }
  
  func actionAccordingTo(status: AVAuthorizationStatus , sourceType: UIImagePickerControllerSourceType, noPermissionMessage: String?) {
    switch status {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: AVMediaType.video) {
        self.checkAuthorizationAccess(granted: $0, sourceType: sourceType, noPermissionMessage: noPermissionMessage)
      }
    case .authorized:
      self.presentImagePicker(sourceType: sourceType)
    case .denied, .restricted:
      self.openSettingsWithUIAlert(message: noPermissionMessage)
    }
  }
  
  func actionAccordingTo(status: PHAuthorizationStatus , sourceType: UIImagePickerControllerSourceType, noPermissionMessage: String?) {
    switch status {
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization {
        self.checkAuthorizationAccess(granted: $0 == .authorized, sourceType: sourceType, noPermissionMessage: noPermissionMessage)
      }
    case .authorized:
      self.presentImagePicker(sourceType: sourceType)
    case .denied, .restricted:
      self.openSettingsWithUIAlert(message: noPermissionMessage)
    }
  }
  
  func checkAuthorizationAccess(granted: Bool, sourceType: UIImagePickerControllerSourceType, noPermissionMessage: String?) {
    if granted {
      self.presentImagePicker(sourceType: sourceType)
    } else {
      self.openSettingsWithUIAlert(message: noPermissionMessage)
    }
  }
  
  func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = sourceType
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func openSettingsWithUIAlert(message: String?) {
    let alertController = UIAlertController (title: "Oops...", message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let settingsAction = UIAlertAction.init(title: "Settings", style: .default) {
      _ in
      guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
        else { return }
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: nil)
      }
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(settingsAction)
    
    present(alertController, animated: true, completion: nil)
  }
  
  func troubleAlert(message: String?) {
    showAlert(title: "Oops...", message: message, alertActions: [UIAlertAction(title: "Got it", style: .cancel)])
  }
  
  func showAlert(title: String?, message: String?, alertActions: [UIAlertAction]) {
    let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
    for alertAction in alertActions {
      alertController.addAction(alertAction)
    }
    present(alertController, animated: true)
  }
}

extension UIImagePickerController {
  override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return .all
  }
}

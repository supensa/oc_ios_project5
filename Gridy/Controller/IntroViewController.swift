//
//  IntroViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 17/03/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, IntroViewDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib!
  }
  
  override func loadView() {
    let introView = IntroView()
    introView.delegate = self
    self.view = introView
  }
  
  // Delegate method: IntroViewDelegate
  func takeRandomImage() -> UIImage? {
    print("Random Picture")
    return nil
  }
  
  // Delegate method: IntroViewDelegate
  func takeCameraImage() -> UIImage? {
    print("Camera Picture")
    return nil
  }
  
  // Delegate method: IntroViewDelegate
  func takePhotoLibraryImage() -> UIImage? {
    print("Library Picture")
    return nil
  }
}


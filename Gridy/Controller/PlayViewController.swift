//
//  PlayViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

protocol PlayViewControllerDelegate {
  func dismissParentViewController()
}

class PlayViewController: UIViewController {
  var images: [UIImage]?
  var delegate: PlayViewControllerDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    let image = UIImage(named: "Logo")
    let playView = PlayView(image: images![1])
    playView.delegate = self
    playView.setupIn(parentView: self.view)
  }
}

extension PlayViewController: PlayViewDelegate {
  // Delegate function: PlayViewDelegate
  func startNewGame() {
    self.delegate.dismissParentViewController()
  }
}

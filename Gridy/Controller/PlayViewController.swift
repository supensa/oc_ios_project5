//
//  PlayViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
  var images: [Image]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let playView = PlayView.init(images: images!)
    playView.delegate = self
    playView.setupIn(parentView: self.view)
  }
}

extension PlayViewController: PlayViewDelegate {
  // Delegate function: PlayViewDelegate
  func startNewGame() {
    dismiss(animated: true, completion: nil)
  }
}

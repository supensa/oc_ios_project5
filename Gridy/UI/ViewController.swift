//
//  ViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var startBoard: StartBoardView!
  var game: Game!
  var imagesId: [Int]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Remove when previous controller is implemented
    imagesId = fakeImages()
    game = Game(imagesId)
    startBoard = StartBoardView(cellCount: imagesId.count)
  }
  
  func fakeImages() -> [Int] {
    let board = Board()
    let max = board.height * board.width
    return Array(1...max)
  }
}

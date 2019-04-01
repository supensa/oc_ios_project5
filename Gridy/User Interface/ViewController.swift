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
  var imagesOrder: [Int]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // TODO: Remove when previous controller is implemented
    imagesOrder = makeImagesOrder()
    game = Game(imagesOrder)
    startBoard = StartBoardView(cellCount: imagesOrder.count)
  }
  
  func makeImagesOrder() -> [Int] {
    let board = Game.boardFactory.makeBoard()
    let max = board.height * board.width
    return Array(1...max)
  }
}

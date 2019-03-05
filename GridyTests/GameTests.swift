//
//  GameTests.swift
//  GridyTests
//
//  Created by Spencer Forrest on 05/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import XCTest
@testable import Gridy

class GameTests: XCTestCase {
  var game: Game!
  
  override func setUp() {
    super.setUp()
    let initial = Board()
    let main = Board()
    let numberMaxImages = main.width * main.height
    game = Game(main: main,
                initial: initial,
                imagesOrder: Array(1...numberMaxImages))
  }
  
  func testNewInitialBoard_BoardIsFull() {
    XCTAssertTrue(game.initialBoard.isFull())
  }
}

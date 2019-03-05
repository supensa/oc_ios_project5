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
  var rules: Rules!
  
  override func setUp() {
    super.setUp()
    let main = Board()
    let numberMaxImages = main.width * main.height
    game = Game(main: main,
                initial: Board(),
                imagesOrder: Array(1...numberMaxImages))
    rules = Rules()
  }
  
  func testNewInitialBoard_BoardIsFull() {
    XCTAssertTrue(game.initialBoard.isFull())
  }
  
  func testNewInitialBoard_BoardIsNotInOrder() {
    XCTAssertFalse(rules.isMatching(game.initialBoard))
  }
}

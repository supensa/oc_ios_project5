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
    let board = Board()
    let imageCount = board.cellCount
    let imagesOrder = Array(1...imageCount)
    game = Game(imagesOrder)
    
  }
  
  func testNewInitialBoard_BoardIsFull() {
    XCTAssertTrue(game.startingBoard.isFull())
  }
  
  func testNewInitialBoard_BoardIsNotInOrder() {
    let rules = Rules()
    XCTAssertFalse(rules.isMatching(game.startingBoard))
  }
}

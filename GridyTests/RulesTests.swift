//
//  RuleTests.swift
//  GridyTests
//
//  Created by Spencer Forrest on 05/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

import XCTest
@testable import Gridy

class RulesTests: XCTestCase {
  var board: Board!
  var rules: Rules!
  
  override func setUp() {
    super.setUp()
    board = Board()
    rules = Rules()
  }
  
  func testEmptyBoard_IsNotWin() {
    XCTAssertFalse(rules.isWin(board))
  }
  
  func testBoardNotFull_IsNotWin() {
    let position = Position(column: 1, row: 1)
    
    XCTAssertNoThrow(try board.place(1, at: position))
    XCTAssertFalse(rules.isWin(board))
  }
  
  func testBoardFullNotInOrder_IsNotWin() {
    var imageId = board.width * board.height
    
    for row in 1...board.height {
      for column in 1...board.width {
        let position = Position(column: column, row: row)
        XCTAssertNoThrow(try board.place(imageId, at: position))
        imageId -= 1
      }
    }
    
    XCTAssertFalse(rules.isWin(board))
  }
  
  func testBoardFullInOrder_IsWin() {
    var imageId = 1
    
    for row in 1...board.height {
      for column in 1...board.width {
        let position = Position(column: column, row: row)
        XCTAssertNoThrow(try board.place(imageId, at: position))
        imageId += 1
      }
    }
    
    XCTAssertTrue(rules.isWin(board))
  }
}

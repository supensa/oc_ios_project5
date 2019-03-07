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
  
  func testNewStartingBoard_BoardIsFull() {
    XCTAssertTrue(game.startingBoard.isFull())
  }
  
  func testNewInitialBoard_BoardIsNotInOrder() {
    let rules = Rules()
    XCTAssertFalse(rules.areOrderedImages(on: game.startingBoard))
  }
  
  func testNewFinishingBoard_BoardIsEmpty() {
    XCTAssertTrue(game.finishingBoard.countImagesPlaced() == 0)
  }
  
  func testStartingBoardNotFull_EmptyPositionNotNil() {
    let position = Position(column: 1, row: 1)
    _ = game.startingBoard.remove(from: position)
    
    XCTAssertFalse(game.startingBoard.isFull())
    XCTAssertNotNil(game.findAnEmptyCell())
  }
  
  func testOutOfBound_PlacedOnFirstEmptyStartingBoardCell() {
    let firstPosition = Position(column: 2, row: 3)
    _ = game.startingBoard.remove(from: firstPosition)!
    let secondPosition = Position(column: 3, row: 1)
    let imageId = game.startingBoard.remove(from: secondPosition)!
    
    XCTAssertFalse(game.startingBoard.isFull())
    
    let outOfBoundPosition = Position(column: 0, row: 0)
    game.place(imageId, at: outOfBoundPosition)
    let sameImageId = game.startingBoard.getImageId(from: firstPosition)
    
    XCTAssertTrue(imageId == sameImageId)
  }
}

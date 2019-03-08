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
  var startBoard: Board!
  var answerBoard: Board!
  
  override func setUp() {
    super.setUp()
    let board = Board()
    let imageCount = board.width * board.height
    let imagesOrder = Array(1...imageCount)
    startBoard = Board()
    answerBoard = Board()
    game = Game(startBoard, answerBoard, imagesOrder)
  }
  
  func testNewStartBoard_BoardIsFull() {
    XCTAssertTrue(startBoard.isFull())
  }
  
  func testNewStartBoard_BoardIsNotInOrder() {
    let rules = Rules()
    XCTAssertFalse(rules.areOrderedImages(on: startBoard))
  }
  
  func testNewAnswerBoard_BoardIsEmpty() {
    XCTAssertTrue(answerBoard.countImagesPlaced() == 0)
  }
  
  func testMoveFromStartBoardToOutOfPosition_PlacedOnFirstEmptyStartBoardCell() {
    let positionOne = Position(column: 1, row: 1)
    _ = startBoard.remove(from: positionOne)
    
    XCTAssertNil(startBoard.getImageId(from: positionOne))
    
    let positionTwelve = Position(column: 4, row: 3)
    let provenance = Provenance(boardType: .start, position: positionTwelve)
    let outOfBoundPosition = Position(column: 0, row: 0)
    let imageId = startBoard.getImageId(from: positionTwelve)
    game.move(from: provenance, to: outOfBoundPosition)
    let sameImageId = startBoard.getImageId(from: positionOne)
    
    XCTAssertTrue(imageId == sameImageId)
    XCTAssertNil(startBoard.getImageId(from: positionTwelve))
  }
  
  func testMoveFromAnswerBoardToOutOfPosition_PlacedOnFirstEmptyStartBoardCell() {
    let positionOne = Position(column: 1, row: 1)
    let imageId = startBoard.remove(from: positionOne)
    let positionTwelve = Position(column: 4, row: 3)
    try! answerBoard.place(imageId!, at: positionTwelve)
    
    XCTAssertNil(startBoard.getImageId(from: positionOne))
    XCTAssertTrue(answerBoard.countImagesPlaced() == 1)
    
    let provenance = Provenance(boardType: .answer, position: positionTwelve)
    let outOfBoundPosition = Position(column: 0, row: 0)
    game.move(from: provenance, to: outOfBoundPosition)
    let sameImageId = startBoard.getImageId(from: positionOne)
    
    XCTAssertTrue(imageId == sameImageId)
    XCTAssertNil(answerBoard.getImageId(from: positionTwelve))
  }
  
  func testMoveFromStartBoardToOccupiedCell_MovedBackToPreviousCell() {
    let positionOne = Position(column: 1,row: 1)
    let positionTwo = Position(column: 2,row: 1)
    let imageIdOne = startBoard.getImageId(from: positionOne)
    let imageIdTwo = startBoard.getImageId(from: positionTwo)
    let provenanceOne = Provenance(boardType: .start, position: positionOne)
    let provenanceTwo = Provenance(boardType: .start, position: positionTwo)
    game.move(from: provenanceOne, to: positionOne)
    game.move(from: provenanceTwo, to: positionOne)
    let sameImageIdOne = answerBoard.getImageId(from: positionOne)
    let sameImageIdTwo = startBoard.getImageId(from: positionTwo)
    
    XCTAssertTrue(sameImageIdOne == imageIdOne)
    XCTAssertTrue(sameImageIdTwo == imageIdTwo)
  }
  
  func testMoveFromAnswerBoardToOccupiedCell_MovedBackToPreviousCell() {
    let imageIdOne = 100
    let imageIdTwo = 200
    let positionOne = Position(column: 1,row: 1)
    let positionTwo = Position(column: 2,row: 1)
    try! answerBoard.place(imageIdOne, at: positionOne)
    try! answerBoard.place(imageIdTwo, at: positionTwo)
    let provenanceTwo = Provenance(boardType: .answer, position: positionTwo)
    game.move(from: provenanceTwo, to: positionOne)
    let sameImageIdOne = answerBoard.getImageId(from: positionOne)
    let sameImageIdTwo = answerBoard.getImageId(from: positionTwo)
    
    XCTAssertTrue(sameImageIdOne == imageIdOne)
    XCTAssertTrue(sameImageIdTwo == imageIdTwo)
  }
}

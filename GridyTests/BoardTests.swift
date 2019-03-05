//
//  GridyTests.swift
//  GridyTests
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

@testable import Gridy
import XCTest


class BoardTests: XCTestCase {
  var board: Board!
  
  override func setUp() {
    super.setUp()
    board = Board()
  }
  
  func testNewBoard_NoImage() {
    XCTAssertEqual(0, board.countImagesPlaced())
  }
  
  func testPlaceOneImage_BoardNotFull() {
    let position = Position(column: 3, row: 2)
    
    XCTAssertNoThrow(try board.place(1, at: position))
    XCTAssertFalse(board.isFull())
  }
  
  func testAllImagesPlaced_BoardIsFull() {
    var imageId = 1
    
    for column in 1...board.width {
      for row in 1...board.height {
        let position = Position(column: column, row: row)
        XCTAssertNoThrow(try board.place(imageId, at: position))
        imageId += 1
      }
    }
    
    XCTAssertTrue(board.isFull())
  }
  
  func testPlaceOneImageInBounds_GetTheImage() {
    let position = Position(column: 1, row: 1)
    let imageId = 1
    
    XCTAssertNoThrow(try! board.place(imageId, at: position))
    
    let placedImage = board.get(from: position)
    
    XCTAssertEqual(1, board.countImagesPlaced())
    XCTAssertEqual(placedImage, imageId)
  }
  
  func testImagePlaced_RemoveTheImage() {
    let position = Position(column: 1, row: 1)
    let imageId = 13
    
    XCTAssertNoThrow(try! board.place(imageId, at: position))
    XCTAssertEqual(1, board.countImagesPlaced())
    
    let placedImage = board.remove(from: position)
    
    XCTAssertEqual(placedImage, imageId)
    XCTAssertEqual(0, board.countImagesPlaced())
  }
  
  func testEmptySpace_GetNil() {
    let position = Position(column: 2, row: 3)
    
    XCTAssertNil(board.get(from: position))
  }
  
  func testPlaceOnOccupiedSpace_Error() {
    let position = Position(column: 2, row: 2)
    let imageId = 1
    
    XCTAssertNoThrow(try! board.place(imageId, at: position))
    
    var placedImage = board.get(from: position)
    
    XCTAssertEqual(1, board.countImagesPlaced())
    XCTAssertEqual(placedImage, imageId)
    
    let newImageId = 2
    
    XCTAssertThrowsError(try board.place(newImageId, at: position)) {
      (error) in
      XCTAssertEqual(error as! BoardError, BoardError.spaceOccupied)
    }
    
    placedImage = board.get(from: position)
    
    XCTAssertEqual(1, board.countImagesPlaced())
    XCTAssertEqual(placedImage, imageId)
  }
  
  func testPlaceOneImageOutOfBound_Error() {
    let position = Position(column: 0, row: 0)
    let imageId = 1
    
    XCTAssertThrowsError(try board.place(imageId, at: position)) {
      (error) in
      XCTAssertEqual(error as! BoardError, BoardError.badPosition)
    }
  }
}

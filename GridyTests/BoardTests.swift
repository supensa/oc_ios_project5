//
//  GridyTests.swift
//  GridyTests
//
//  Created by Spencer Forrest on 04/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

@testable import Gridy
import XCTest


class GridyTests: XCTestCase {
  var board: Board!
  
  override func setUp() {
    super.setUp()
    board = Board()
  }
  
  func testNewBoardHasNoImage() {
    XCTAssertEqual(0, board.countImagesPlaced())
  }
  
  func testCanAddOneImage() {
    let column = 1
    let row = 1
    let image = 1
    board.place(column, row, image)
    
    XCTAssertEqual(1, board.countImagesPlaced())
    
    let placedImage = board.get(column, row)
    
    XCTAssertEqual(placedImage, image)
  }
}

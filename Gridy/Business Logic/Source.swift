//
//  Source.swift
//  Gridy
//
//  Created by Spencer Forrest on 15/03/2019.
//  Copyright © 2019 Spencer Forrest. All rights reserved.
//

enum BoardType {
  case start, answer
}

struct Source {
  var boardType: BoardType
  var position: Position
}

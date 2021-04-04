//
//  PlayViewController.swift
//  Gridy
//
//  Created by Spencer Forrest on 05/04/2018.
//  Copyright © 2018 Spencer Forrest. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
  
  var playView: PlayView!
  var imagesWithInitialPosition: [Image]!
  var hintImage: UIImage!
  
  private static var numberOftile: Int = { return 16 }()
  private var puzzleGridModel = PuzzleGridModel(numberOftile: numberOftile)
  private var containerGridModel = ContainerGridModel(numberOftile: numberOftile)
  private var score = 0
  
  private var isLandscapeOrientation: Bool {
    return UIApplication.shared.statusBarOrientation.isLandscape
  }
  
  private var isPreviousOrientationLandscape: Bool?;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    
    playView = PlayView(hintImage: hintImage, puzzlePieceViews: makeRandomOrderImageViews())
    playView.delegate = self
    playView.headerView.delegate = self
    playView.backgroundColor = UIColor.white
    view.addSubview(playView)
    
    let margin = self.view.layoutMarginsGuide
    NSLayoutConstraint.setAndActivate([
      playView.topAnchor.constraint(equalTo: margin.topAnchor),
      playView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
      playView.leftAnchor.constraint(equalTo: margin.leftAnchor),
      playView.rightAnchor.constraint(equalTo: margin.rightAnchor),
      ])
  }
    
  override func viewWillLayoutSubviews() {
    let isIPad = traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular
    
    if isIPad  {
      // first time laying out subviews case
      if self.isPreviousOrientationLandscape == nil {
        self.isPreviousOrientationLandscape = !isLandscapeOrientation
      }
      
      guard let isPreviousOrientationLandscape = isPreviousOrientationLandscape else { return }
      
      // check if orientation changed and update layout accordingly
      if isLandscapeOrientation && !isPreviousOrientationLandscape {
        playView.activateRegularLandscapeLayout()
        self.isPreviousOrientationLandscape = isLandscapeOrientation
      }
      else if !isLandscapeOrientation && isPreviousOrientationLandscape {
        playView.activateRegularPortraitLayout()
        self.isPreviousOrientationLandscape = isLandscapeOrientation
      }
    }
  }
  
  private func makeRandomOrderImageViews() -> [UIImageView] {
    var array = [UIImageView]()
    let max = imagesWithInitialPosition.count - 1
    for index in 0...max {
      guard let imageModel = imagesWithInitialPosition.randomPop()
        else { fatalError("Image model is null") }
      let imageView = UIImageView(image: imageModel.image)
      imageView.tag = imageModel.id
      array.append(imageView)
      containerGridModel.updatePosition(id: imageModel.id, position: index)
    }
    return array
  }
}

// MARK: Delegation to handle PuzzlePieceView logic
extension PlayViewController: PlayViewDelegate {
  
  func handleShareButtonTapped() {
    let text = "My score is \(score)"
    let items = [
      hintImage as Any,
      text
    ]
    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.playView.shareButton
    present(activityViewController, animated: true, completion: nil)
  }
  
  func handlePuzzleViewDrag(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard let puzzlePieceView = gestureRecognizer.view as? UIImageView else { return }
    
    playView.bringSubviewToFront(puzzlePieceView)
    
    // Moving the puzzlePieceView
    if gestureRecognizer.state == .changed {
      
      let translation = gestureRecognizer.translation(in: playView)
      
      puzzlePieceView.center = CGPoint(x: puzzlePieceView.center.x + translation.x,
                                       y: puzzlePieceView.center.y + translation.y)
      gestureRecognizer.setTranslation(CGPoint.zero, in: playView)
    }
    
    // Logic when it stops moving
    if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
      // This is the logic for a drag into the puzzleGridView
      if playView.puzzleGridView.frame.contains(puzzlePieceView.center) {
        placeInsidePuzzleGridViewIfPossible(puzzlePieceView)
      }
        // This is the logic for a drag outside the puzzleGridView
      else {
        if puzzleGridModel.contains(id: puzzlePieceView.tag) {
          updateScore()
        }
        placeInsideContainerGridView(puzzlePieceView)
      }
    }
  }
  
  private func placeInsidePuzzleGridViewIfPossible(_ puzzlePieceView: UIImageView) {
    let center = playView.convertCenterPointCoordinateSystem(of: puzzlePieceView, to: playView.puzzleGridView)
    
    if let position = playView.puzzleGridView.findTilePositionContaining(center),
      let tile = playView.puzzleGridView.getTile(from: position) {
      
      let shouldBePlaced = shouldBePlacedInsidePuzzleGridView(tile,
                                                              in: position,
                                                              for: puzzlePieceView)
      
      if shouldBePlaced {
        
        playView.place(puzzlePieceView, inside: tile)
        updateScore()
        
        if puzzleGridModel.isAwin() {
          presentWinningAlert()
          playView.layoutEndGameMode()
        }
        
      } else {
        placeInInitialTile(puzzlePieceView)
      }
      
    } // Case when the center is inside of PuzzleGridView but outside a tile.
    else {
      placeInInitialTile(puzzlePieceView)
    }
  }
  
  private func updateScore() {
    score += 1
    playView.headerView.scoreLabel.text = "\(score)"
  }
  
  private func presentWinningAlert() {
    let title = score == PlayViewController.numberOftile ? "Perfect Score" : "Congratulation"
    let message = "Puzzle completed.\nYou cannot move the pieces or see the hint anymore."
    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  private func placeInsideContainerGridView(_ puzzlePieceView: UIImageView) {
    if let position = findFirstEmptyTilePositionFromContainerGrid(puzzlePieceView),
      let containerGridTile = playView.containerGridView.getTile(from: position) {
      
      playView.place(puzzlePieceView, inside: containerGridTile)
      
    }
    else {
      fatalError("No tile found")
    }
  }
  
  private func placeInInitialTile(_ puzzlePieceView: UIImageView) {
    if let position = puzzleGridModel.position(id: puzzlePieceView.tag),
      let puzzleGridTile = playView.puzzleGridView.getTile(from: position) {
      
      playView.place(puzzlePieceView, inside: puzzleGridTile)
      
    }
    else {
      placeInsideContainerGridView(puzzlePieceView)
    }
  }
  
  private func findFirstEmptyTilePositionFromContainerGrid(_ puzzlePieceView: UIImageView) -> Int? {
    let id = puzzlePieceView.tag
    containerGridModel.updatePosition(id: id, position: nil)
    puzzleGridModel.updatePosition(id: id, position: nil)
    let position = containerGridModel.findFirstEmptyTilePosition()
    containerGridModel.updatePosition(id: id, position: position)
    return position
  }
  
  private func shouldBePlacedInsidePuzzleGridView(_ tile: UIView, in position: Int, for puzzlePieceView: UIImageView) -> Bool {
    let isFreeTile = puzzleGridModel.isTileFree(at: position)
    if isFreeTile {
      containerGridModel.updatePosition(id: puzzlePieceView.tag, position: nil)
      puzzleGridModel.updatePosition(id: puzzlePieceView.tag, position: position)
    }
    return isFreeTile
  }
}

// MARK: Delegation to handle New Game Button tap
extension PlayViewController: HeaderViewDelegate {
  
  func newGameButtonTapped() {
    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

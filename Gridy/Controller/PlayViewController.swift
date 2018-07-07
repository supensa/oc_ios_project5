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
  var images: [Image]!
  var hintImage: UIImage!
  
  private var puzzleGridModel: GridModel!
  private var containerGridModel: GridModel!
  private var score = 0
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.puzzleGridModel = GridModel(numberOftile: images.count)
    self.containerGridModel = GridModel(numberOftile: images.count)
    
    randomizeImageViewsPosition()
    
    playView = PlayView(hintImage: hintImage, images: images)
    
    playView.delegate = self
    
    playView.puzzleGridView.delegate = self
    playView.containerGridView.delegate = self
    
    playView.puzzleGridView.datasource = self
    playView.containerGridView.datasource = self
    
    playView.header.delegate = self
    
    playView.setup(parentView: self.view)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
      let isLandscape = view.bounds.width >= view.bounds.height
      playView.layoutIfNeeded()
      playView.deactivateConstraints()
      if isLandscape {
        // Landscape constraints for IPad
        playView.setupConstraintsInLandscapeEnvironment(offset: 90)
      } else {
        // Portrait constraints for IPad
        playView.setupConstraintsInPortraitEnvironment(offset: 130)
      }
      playView.activateConstraints()
    }
  }
  
  override func viewDidLayoutSubviews() {
    refreshLayout()
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let horizontaSizeClassChanged = previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
    let verticalSizeClassChanged = previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass
    
    if verticalSizeClassChanged || horizontaSizeClassChanged {
      playView.deactivateConstraints()
      let sizeClass = (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass)
      switch sizeClass {
      case (.regular, .regular):
        playView.updateLabels(fontSize: 30)
      case (.compact, .regular):
        playView.layoutIfNeeded()
        playView.updateLabels(fontSize: 15)
        playView.setupConstraintsInPortraitEnvironment(offset: 0)
      case (.compact, .compact), (.regular,.compact):
        playView.layoutIfNeeded()
        playView.updateLabels(fontSize: 15)
        playView.setupConstraintsInLandscapeEnvironment(offset: 44)
      default: break
      }
      playView.activateConstraints()
    }
  }
  
  private func refreshLayout() {
    playView.layoutIfNeeded()
    for imageView in  playView.imageViews {
      let idImage = imageView.tag
      if let position = puzzleGridModel.position(id: idImage) {
        let tile =  playView.puzzleGridView.subviews[position]
        let frame =  playView.convertFrame(of: tile, in:  playView.puzzleGridView)
        imageView.frame = frame
      } else if let position = containerGridModel.position(id: idImage) {
        let tile =  playView.containerGridView.subviews[position]
        let frame =  playView.convertFrame(of: tile, in:  playView.containerGridView)
        imageView.frame = frame
      }
    }
    playView.header.scoreLabel?.text = "\(score)"
    let smallSize =  playView.containerGridView.subviews[0].frame.size
    let bigSize =  playView.puzzleGridView.subviews[0].frame.size
    print("Container Tile size: \(smallSize)")
    print("Puzzle Tile size: \(bigSize)")
  }
  
  private func randomizeImageViewsPosition() {
    var index = Array(0...images.count-1)
    for image in images {
      if let randomIndex = index.randomPop() {
        containerGridModel.updatePosition(id: image.id, position: randomIndex)
      }
    }
  }
}

extension PlayViewController: PlayViewDelegate {
  func moveImageView(_ sender: UIPanGestureRecognizer) {
    if let view = sender.view {
      let tag = view.tag
      self.playView.bringSubview(toFront: view)
      let translation = sender.translation(in: self.view)
      let newPoint = CGPoint(x: view.center.x + translation.x,
                             y: view.center.y + translation.y)
      view.center = newPoint
      sender.setTranslation(CGPoint.zero, in: self.view)
      
      if sender.state == UIGestureRecognizerState.ended {
        if playView.puzzleGridView.frame.contains(view.center) {
          let max = playView.puzzleGridView.subviews.count - 1
          for index in 0...max {
            let tile = playView.puzzleGridView.subviews[index]
            let center = playView.convertCoordinates(of: view.center, into: playView.puzzleGridView)
            if tile.frame.contains(center) {
              if puzzleGridModel.isTileFree(at: index) && index != puzzleGridModel.position(id: tag) {
                containerGridModel.updatePosition(id: tag, position: nil)
                puzzleGridModel.updatePosition(id: tag, position: index)
                self.score += 1
                break
              }
              break
            }
          }
        } else {
          containerGridModel.updatePosition(id: tag, position: nil)
          if let _ = puzzleGridModel.position(id: tag) { self.score += 1 }
          puzzleGridModel.updatePosition(id: tag, position: nil)
          let position = containerGridModel.getFreeTilePosition()
          containerGridModel.updatePosition(id: tag, position: position)
        }
        
        refreshLayout()
        
        if puzzleGridModel.isFull() {
          if puzzleGridModel.isMatching() {
            playView.instructionsLabel.text = "GAME OVER"
            playView.instructionsLabel.font = UIFont(name: Constant.Font.Name.helveticaNeue, size: 35)
            playView.instructionsLabel.textColor = UIColor.red
            for imageView in playView.imageViews {
              imageView.isUserInteractionEnabled = false
            }
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displaySharingOptions))
            playView.instructionsLabel.addGestureRecognizer(tapGestureRecognizer)
            playView.instructionsLabel.isUserInteractionEnabled = true
          }
        }
      }
    }
  }
  
  @objc func displaySharingOptions() {
    let text = "My score is \(score)"
    let items = [hintImage as Any, text as Any]
    let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = view
    present(activityViewController, animated: true, completion: nil)
  }
}

extension PlayViewController: GridViewDelegate {
  func eyeImageViewTapped() {
    playView.bringSubview(toFront: playView.hintView)
    playView.hintView.appearsTemporarily(for: 2)
  }
  
  func gapLength(gridView tag: Int) -> CGFloat {
    if tag == 0 { return Constant.Tiles.Container.gapLength }
    return Constant.Tiles.Puzzle.gapLength
  }
}

extension PlayViewController: GridViewDataSource {
  func getTile(at index: Int, for tag: Int) -> UIView {
    let tile = UIView()
    if tag == 0 {
      tile.layer.borderWidth = 1
      tile.layer.borderColor = GridyColor.janna.cgColor
    }
    tile.backgroundColor = UIColor.white
    return tile
  }
  
  func numberOfTiles(gridView tag: Int) -> Int {
    return images.count
  }
  
  func numberOfTilesPerRow(gridView tag: Int) -> Int {
    if tag == 0 { return Constant.Tiles.Container.countByRow }
    return Constant.Tiles.Puzzle.countByRow
  }
}

extension PlayViewController: HeaderViewDelegate {
  func newGameButtonTapped() {
    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

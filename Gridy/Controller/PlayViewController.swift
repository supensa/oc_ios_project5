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
  
  private var bigGridModel: GridModel!
  private var smallGridModel: GridModel!
  private var score = 0
  
  private var constraints: [NSLayoutConstraint]!
  private var commonConstraints: [NSLayoutConstraint]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bigGridModel = GridModel(numberOftile: images.count)
    self.smallGridModel = GridModel(numberOftile: images.count)
    
    randomizeImageViewsPosition()
    
    playView = PlayView(hintImage: hintImage, images: images)
    
    playView.delegate = self
    
    playView.bigGridView.delegate = self
    playView.smallGridView.delegate = self
    
    playView.bigGridView.datasource = self
    playView.smallGridView.datasource = self
    
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
      if let position = bigGridModel.position(id: idImage) {
        let tile =  playView.bigGridView.subviews[position]
        let frame =  playView.convertFrame(of: tile, in:  playView.bigGridView)
        imageView.frame = frame
      } else if let position = smallGridModel.position(id: idImage) {
        let tile =  playView.smallGridView.subviews[position]
        let frame =  playView.convertFrame(of: tile, in:  playView.smallGridView)
        imageView.frame = frame
      }
    }
    playView.header.scoreLabel?.text = "\(score)"
    let smallSize =  playView.smallGridView.subviews[0].frame.size
    let bigSize =  playView.bigGridView.subviews[0].frame.size
    print("Small Tile size: \(smallSize)")
    print("Big Tile size: \(bigSize)")
  }
  
  private func randomizeImageViewsPosition() {
    var index = Array(0...images.count-1)
    for image in images {
      if let randomIndex = index.randomPop() {
        smallGridModel.updatePosition(id: image.id, position: randomIndex)
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
        if playView.bigGridView.frame.contains(view.center) {
          let max = playView.bigGridView.subviews.count - 1
          for index in 0...max {
            let tile = playView.bigGridView.subviews[index]
            let center = playView.convertCoordinates(of: view.center, into: playView.bigGridView)
            if tile.frame.contains(center) {
              if bigGridModel.isTileFree(at: index) && index != bigGridModel.position(id: tag) {
                smallGridModel.updatePosition(id: tag, position: nil)
                bigGridModel.updatePosition(id: tag, position: index)
                self.score += 1
                break
              }
              break
            }
          }
        } else {
          smallGridModel.updatePosition(id: tag, position: nil)
          if let _ = bigGridModel.position(id: tag) { self.score += 1 }
          bigGridModel.updatePosition(id: tag, position: nil)
          let position = smallGridModel.getFreeTilePosition()
          smallGridModel.updatePosition(id: tag, position: position)
        }
        
        refreshLayout()
        
        if bigGridModel.isFull() {
          if bigGridModel.isMatching() {
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
    if tag == 0 { return Constant.Tiles.Small.gapLength }
    return Constant.Tiles.Big.gapLength
  }
}

extension PlayViewController: GridViewDataSource {
  func getTile(at index: Int) -> UIView {
    let tile = UIView()
    tile.backgroundColor = UIColor.lightGray
    return tile
  }
  
  func numberOfTiles(gridView tag: Int) -> Int {
    return images.count
  }
  
  func numberOfTilesPerRow(gridView tag: Int) -> Int {
    if tag == 0 { return Constant.Tiles.Small.countByRow }
    return Constant.Tiles.Big.countByRow
  }
}

extension PlayViewController: HeaderViewDelegate {
  func newGameButtonTapped() {
    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

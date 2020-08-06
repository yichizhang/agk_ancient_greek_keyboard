//
//  TopRowKeyDownHintView.swift
//  AGK
//
//  Created by Yichi on 8/11/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

class TopRowKeyDownHintView: BaseImageLabelView {
  fileprivate var viewFrame: CGRect!
  fileprivate let keyLetter: String!
  fileprivate let style: TopRowKeyDownHintViewStyle!
  fileprivate let topExpansion: CGFloat!
  fileprivate var imageProvider: KeyImageProvider!

  init(
    keyFrame: CGRect,
    keyLetter: String,
    style: TopRowKeyDownHintViewStyle,
    topExpansion: CGFloat,
    imageProvider: KeyImageProvider) {
    self.keyLetter = keyLetter
    self.style = style
    self.topExpansion = topExpansion
    self.imageProvider = imageProvider

    super.init(frame: keyFrame)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    foregroundLabel.attributedText =
      NSAttributedString(
        string: keyLetter,
        attributes: [
          NSAttributedString.Key.font: style.font,
          NSAttributedString.Key.foregroundColor: style.textColor,
          NSAttributedString.Key.paragraphStyle: paragraphStyle,
      ])

    backgroundColor = UIColor.clear
    self.configureFrameWithKeyFrame(keyFrame)
  }

  required
  init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureFrameWithKeyFrame(_ keyFrameInSuperview: CGRect) {
    var viewSize = keyFrameInSuperview.size
    viewSize.height += topExpansion

    viewFrame = CGRect(origin: CGPoint.zero, size: viewSize)

    var frameOrigin = keyFrameInSuperview.origin
    frameOrigin.y -= topExpansion

    var frame = CGRect(origin: frameOrigin, size: viewSize)

    frame = frame.integral

    self.frame = frame
  }

  override
  func frameDidChange() {
    backgroundImageView.image = imageProvider.keyImage(
      buttonBounds: viewFrame,
      keyFrame: viewFrame,
      cornerRadius: style.cornerRadius,
      keyColor: style.backgroundColor,
      keyShadowColor: style.shadowColor)
  }
}

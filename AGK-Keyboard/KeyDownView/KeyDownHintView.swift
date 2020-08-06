//
//  KeyDownHintView.swift
//  AGK
//
//  Created by Yichi on 6/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit

class KeyDownHintView: UIView {
  var keyLetter: String!
  var topIncreaseAmount: CGFloat = 0

  fileprivate var style: KeyDownHintViewStyle!

  fileprivate var keyFrame = CGRect.zero
  fileprivate var expandedKeyFrame = CGRect.zero

  fileprivate let keyDownPathOffset = CGPoint(x: 1, y: 1)

  init(
    keyFrame: CGRect,
    keyLetter: String,
    style: KeyDownHintViewStyle) {
    super.init(frame: keyFrame)

    self.keyLetter = keyLetter
    self.style = style
    backgroundColor = UIColor.clear

    configureFrameWithKeyFrame(keyFrame)
  }

  required
  init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureFrameWithKeyFrame(_ keyFrameInSuperview: CGRect) {
    keyFrame = CGRect(origin: CGPoint.zero, size: keyFrameInSuperview.size)

    let ySpacing: CGFloat = 0
    expandedKeyFrame = CGRect(
      origin: CGPoint.zero,
      size: style.expandedKeySizeWithKeySize(keyFrame.size))

    expandedKeyFrame = expandedKeyFrame.integral

    keyFrame.origin = CGPoint(
      x: (expandedKeyFrame.width - keyFrame.width) * 0.5,
      y: expandedKeyFrame.height + ySpacing)

    keyFrame = keyFrame.integral

    var frame = CGRect(
      x: keyFrameInSuperview.origin.x - keyFrame.origin.x,
      y: keyFrameInSuperview.origin.y - keyFrame.origin.y,
      width: max(keyFrame.width, expandedKeyFrame.width),
      height: keyFrame.height + expandedKeyFrame.height + ySpacing)

    frame = frame.insetBy(dx: -keyDownPathOffset.x, dy: -keyDownPathOffset.y)
    frame = frame.integral

    self.frame = frame
  }

  fileprivate lazy var keyDownPath: UIBezierPath = { [unowned self] in
    let keyFrame = self.keyFrame
    let expandedKeySize = self.expandedKeyFrame.size

    let minorRadius = self.style.cornerRadius
    let majorRadius = minorRadius! * 2.0

    let path = TurtleBezierPath()
    path.lineWidth = 0
    path.lineCapStyle = CGLineCap.round

    let PI = CGFloat(3.1415926)
    let deg = CGFloat(45)
    let k = CGFloat(1 - cos(PI * deg / 180))
    let j = CGFloat(sin(PI * deg / 180))

    let lostWidth = (expandedKeySize.width - keyFrame.width - 4 * majorRadius * k) * 0.5
    let lostHeight = 2 * majorRadius * j + lostWidth
    let slopeLength = lostWidth * sqrt(2)

    let a = (keyFrame.height > keyFrame.width) ? (lostHeight * 0.7) : (lostHeight * 0.5)
    let b = lostHeight - a

    path.home()
    path.rightArc(majorRadius, turn: 90) // 1
    path.forward(expandedKeySize.width - 2 * majorRadius) // 2
    path.rightArc(majorRadius, turn: 90) // 3
    path.forward(expandedKeySize.height - majorRadius - a) // 4

    path.rightArc(majorRadius, turn: deg) // 5
    path.forward(slopeLength) // 6
    path.leftArc(majorRadius, turn: deg) // 7

    path.forward(keyFrame.height - minorRadius! - b) // 8
    path.rightArc(minorRadius!, turn: 90) // 9
    path.forward(keyFrame.width - 2 * minorRadius!) // 10
    path.rightArc(minorRadius!, turn: 90) // 11
    path.forward(keyFrame.height - minorRadius! - b) // 12

    path.leftArc(majorRadius, turn: deg) // 13
    path.forward(slopeLength) // 14
    path.rightArc(majorRadius, turn: deg) // 15

    path.apply(
      CGAffineTransform(
        translationX: keyFrame.midX - path.bounds.midX,
        y: keyFrame.maxY - path.bounds.height + majorRadius))

    return path
  }()

  func drawKeyDownPath(_ keyDownPath: UIBezierPath, fillColor: UIColor) {
    let context = UIGraphicsGetCurrentContext()

    context!.saveGState()
    context!.translateBy(x: keyDownPathOffset.x, y: keyDownPathOffset.y)

    /* context, offset, blur, color */
    context!.setShadow(offset: CGSize(width: 0, height: 0.5),
                       blur: 2,
                       color: style.shadowColor.withAlphaComponent(0.5).cgColor)

    fillColor.setFill()
    keyDownPath.fill()
    context!.restoreGState()
  }

  override
  func draw(_: CGRect) {
    drawKeyDownPath(keyDownPath, fillColor: style.backgroundColor)

    let stringRect = expandedKeyFrame
    KeyboardGraphicsRenderer.drawTextAtCenterInRect(
      stringRect,
      text: keyLetter,
      textColor: style.textColor,
      textFont: style.font)
  }
}

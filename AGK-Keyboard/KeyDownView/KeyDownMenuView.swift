//
//  KeyDownMenuView.swift
//  AGK
//
//  Created by Yichi on 6/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit
fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

enum KeyDownMenuOptionAlignment {
  case vertical
  case horizontal
  case grid
}

class KeyDownMenuView: UIView {
  fileprivate(set) var viewModel: KeyDownMenuViewModel!
  fileprivate(set) var style: KeyDownMenuViewStyle!

  fileprivate var keyFrame = CGRect.zero
  fileprivate var expandedKeyFrame = CGRect.zero

  fileprivate let keyDownPathOffset = CGPoint(x: 1, y: 1)
  lazy var keyDownPath: UIBezierPath = { [unowned self] in
    self.createKeyDownPath()
  }()

  init(
    keyFrame: CGRect,
    model: KeyDownMenuModel,
    style: KeyDownMenuViewStyle,
    optionAlignment: KeyDownMenuOptionAlignment = .vertical) {
    super.init(frame: keyFrame)

    self.style = style
    viewModel = KeyDownMenuViewModel(
      model: model,
      view: self,
      optionAlignment: optionAlignment)

    backgroundColor = UIColor.clear
    configureFrameWithKeyFrame(keyFrame)
  }

  required
  init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureFrameWithKeyFrame(_ keyFrameInSuperview: CGRect) {
    keyFrame = CGRect(origin: CGPoint.zero, size: keyFrameInSuperview.size)

    let ySpacing: CGFloat = 10
    let expandedKeySize = viewModel.expandedKeySize
    var expandedKeyFrame = CGRect(
      x: 0,
      y: 0,
      width: expandedKeySize.width,
      height: expandedKeySize.height)

    expandedKeyFrame = expandedKeyFrame.integral

    var keyFrameOrigX: CGFloat = 0
    let sidePadding = style.sidePadding
    if keyFrameInSuperview.midX + expandedKeyFrame.width * 0.5 > style.superviewWidth {
      keyFrameOrigX = expandedKeyFrame.width - (style.superviewWidth - keyFrameInSuperview.minX - sidePadding.x)
    } else if keyFrameInSuperview.midX - expandedKeyFrame.width * 0.5 < 0 {
      keyFrameOrigX = style.sidePadding.x
    } else {
      keyFrameOrigX = (expandedKeyFrame.width - keyFrame.width) * 0.5
    }

    keyFrame.origin = CGPoint(
      x: keyFrameOrigX,
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

    let optionIndex: Int? = viewModel.selectedOptionIndex ?? viewModel.defaultOptionIndex

    if let optionIndex = optionIndex {
      let optionRect = viewModel.optionRectArray[optionIndex]

      let path = UIBezierPath(roundedRect: optionRect, cornerRadius: style.cornerRadius)
      tintColor.setFill()
      path.fill()
    }

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    for (i, optionRect) in viewModel.optionRectArray.enumerated() {
      let title = viewModel.displayStringForOptionAtIndex(i)
      let titleColor: UIColor! = (optionIndex == i) ? style.selectedTextColor : style.textColor
      KeyboardGraphicsRenderer.drawTextAtCenterInRect(
        optionRect,
        text: title,
        textColor: titleColor,
        textFont: style.font)
    }
  }

  func updateSelectionWithPoint(_ touchPointInSuperview: CGPoint) {
    guard let superview = superview else { return }

    let point = superview.convert(touchPointInSuperview, to: self)
    viewModel.updateSelectionWithPoint(point)
    setNeedsDisplay()
  }

  // MARK: Private

  fileprivate func createKeyDownPath() -> UIBezierPath {
    let keyFrame = self.keyFrame
    let expandedKeySize = viewModel.expandedKeySize

    let path = TurtleBezierPath()
    path.lineWidth = 0
    path.lineCapStyle = CGLineCap.round

    let minorRadius = style.cornerRadius
    let majorRadius = minorRadius

    let kRadius = CGFloat(majorRadius!)
    let lRadius = CGFloat(majorRadius!)

    let lenLeft = keyFrame.minX - kRadius - lRadius
    let lenRight = expandedKeySize.width - keyFrame.maxX - kRadius - lRadius

    path.home()
    path.rightArc(majorRadius!, turn: 90) // 1
    path.forward(expandedKeySize.width - 2 * majorRadius!) // 2
    path.rightArc(majorRadius!, turn: 90) // 3
    path.forward(expandedKeySize.height - 2 * majorRadius!) // 4

    path.rightArc(kRadius, turn: 90) // 5
    path.forward(lenRight) // 6
    path.leftArc(lRadius, turn: 90) // 7

    let extraPadding = minorRadius
    path.forward(keyFrame.height - 2 * minorRadius! + extraPadding!) // 8
    path.rightArc(minorRadius!, turn: 90) // 9
    path.forward(keyFrame.width - 2 * minorRadius!) // 10
    path.rightArc(minorRadius!, turn: 90) // 11
    path.forward(keyFrame.height - 2 * minorRadius! + extraPadding!) // 12

    path.leftArc(lRadius, turn: 90) // 13
    path.forward(lenLeft) // 14
    path.rightArc(kRadius, turn: 90) // 15

    let pathKeyStartX = kRadius + lRadius + lenLeft
    path.apply(
      CGAffineTransform(
        translationX: keyFrame.minX - pathKeyStartX,
        y: keyFrame.maxY - path.bounds.height + majorRadius!))

    return path
  }
}

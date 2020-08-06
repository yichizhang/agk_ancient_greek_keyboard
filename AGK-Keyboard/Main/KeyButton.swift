//  Copyright (c) 2016-present Yichi Zhang. All rights reserved.

import Foundation
import UIKit

class KeyButtonStyle {
  var font: UIFont!

  var foregroundColor: UIColor!
  var backgroundColor: UIColor!
  var selectedForegroundColor: UIColor!
  var selectedBackgroundColor: UIColor!

  var shadowColor: UIColor!

  init(font: UIFont,
       foregroundColor: UIColor,
       backgroundColor: UIColor,
       selectedForegroundColor: UIColor? = nil,
       selectedBackgroundColor: UIColor? = nil,
       shadowColor: UIColor = UIColor.black) {
    self.font = font

    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.selectedForegroundColor = selectedForegroundColor ?? foregroundColor
    self.selectedBackgroundColor = selectedBackgroundColor ?? backgroundColor

    self.shadowColor = shadowColor
  }

  class func cornerRadius(keySize size: CGSize) -> CGFloat {
    return ceil(size.height * 0.1)
  }

  func cornerRadius(keySize size: CGSize) -> CGFloat {
    return KeyButtonStyle.cornerRadius(keySize: size)
  }
}

enum SystemKeySymbol: String {
  case shift = "shift"
  case capsLock = "capsLock"
  case delete = "delete"
  case globe = "globe"
  case enter = "enter"
}

class KeyButton: UIButton {
  var ID: String!

  var keyButtonShapeInset = CGPoint.zero
  var keyFrame: CGRect {
    return frame.insetBy(dx: keyButtonShapeInset.x, dy: keyButtonShapeInset.y)
  }

  var keyBounds: CGRect {
    return bounds.insetBy(dx: keyButtonShapeInset.x, dy: keyButtonShapeInset.y)
  }

  var style: KeyButtonStyle?
  var imageProvider: KeyImageProvider!

  var textOrSymbol: Any?
  fileprivate var keyDownHintView: KeyDownHintView?
  fileprivate var topRowKeyDownHintView: TopRowKeyDownHintView?

  fileprivate func keyBackgroundImageForState(selected: Bool) -> UIImage? {
    guard let style = style else { return nil }

    let buttonBounds = bounds
    let keyFrame = keyBounds
    let cornerRadius = style.cornerRadius(keySize: keyFrame.size)
    let keyShadowColor = style.shadowColor

    return imageProvider.keyImage(
      buttonBounds: buttonBounds,
      keyFrame: keyFrame,
      cornerRadius: cornerRadius,
      keyColor: selected ? style.selectedBackgroundColor : style.backgroundColor,
      keyShadowColor: keyShadowColor!)
  }

  lazy var backgroundImageView: UIImageView! = { [unowned self] in
    let imageView = UIImageView(frame: CGRect.zero)
    imageView.isAccessibilityElement = false
    imageView.translatesAutoresizingMaskIntoConstraints = false

    imageView.contentMode = .center
    imageView.backgroundColor = UIColor.clear

    return imageView
  }()

  lazy var foregroundLabel: UILabel! = { [unowned self] in
    let label = UILabel(frame: CGRect.zero)
    label.isAccessibilityElement = false
    label.translatesAutoresizingMaskIntoConstraints = false

    label.backgroundColor = UIColor.clear

    return label
  }()

  lazy var foregroundImageView: UIImageView! = { [unowned self] in
    let imageView = UIImageView(frame: CGRect.zero)
    imageView.isAccessibilityElement = false
    imageView.translatesAutoresizingMaskIntoConstraints = false

    imageView.contentMode = .center
    imageView.backgroundColor = UIColor.clear

    return imageView
  }()

  fileprivate var viewSet: Set<UIView>!

  fileprivate var frameWidthOfLastLayout = 0
  fileprivate var frameHeightOfLastLayout = 0

  override var isSelected: Bool {
    didSet {
      self.buttonStateDidChange()
    }
  }

  override
  init(frame _: CGRect) {
    super.init(frame: CGRect.zero)
    commonInit()
  }

  required
  init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    backgroundColor = UIColor.clear

    addSubview(backgroundImageView)
    addSubview(foregroundLabel)
    addSubview(foregroundImageView)

    viewSet = Set([backgroundImageView, foregroundLabel, foregroundImageView])
  }

  deinit {
  }

  override
  func layoutSubviews() {
    super.layoutSubviews()

    backgroundImageView.frame = bounds
    foregroundImageView.frame = bounds

    foregroundLabel.sizeToFit()
    foregroundLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)

    if Int(frame.width) != frameWidthOfLastLayout &&
      Int(frame.height) != frameHeightOfLastLayout {
      frameDidChange()

      frameWidthOfLastLayout = Int(frame.width)
      frameHeightOfLastLayout = Int(frame.height)
    }
  }

  //  private - iOS 8.4 defect workaround
  func configureButton() {
    foregroundLabel.text = nil
    foregroundLabel.isHidden = true
    foregroundImageView.image = nil
    foregroundImageView.isHidden = true

    guard let style = style else {
      return
    }

    let backgroundColor: UIColor! = isSelected ? style.selectedBackgroundColor : style.backgroundColor
    let foregroundColor: UIColor! = isSelected ? style.selectedForegroundColor : style.foregroundColor

    backgroundImageView.image = keyBackgroundImageForState(selected: isSelected)

    if let text = textOrSymbol as? String {
      foregroundLabel.text = text
      foregroundLabel.font = style.font
      foregroundLabel.textColor = foregroundColor

      foregroundLabel.isHidden = false
    } else if let symbol = textOrSymbol as? SystemKeySymbol {
      foregroundImageView.image = imageProvider.symbolImage(
        symbol,
        rect: keyBounds,
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor)

      foregroundImageView.isHidden = false
    }
  }

  fileprivate func buttonStateDidChange() {
    configureButton()
  }

  fileprivate func frameDidChange() {
    configureButton()
  }

  func prepareForReuse() {
    style = nil
    textOrSymbol = nil
    isSelected = false

    foregroundLabel.text = nil
    foregroundLabel.isHidden = true
    foregroundImageView.image = nil
    foregroundImageView.isHidden = true

    for view in subviews {
      if viewSet.contains(view) == false {
        view.removeFromSuperview()
      }
    }
  }

  // MARK: Key down hint view
  func setKeyDownHintViewVisible(_ visible: Bool) {
    keyDownHintView?.removeFromSuperview()
    keyDownHintView = nil

    if visible {
      guard let style = style else { return }

      keyDownHintView = KeyDownHintView(
        keyFrame: keyBounds,
        keyLetter: textOrSymbol as? String ?? "",
        style: KeyDownHintViewStyle(
          font: UIFont(name: style.font!.fontName, size: style.font!.pointSize * 1.5),
          cornerRadius: style.cornerRadius(keySize: keyFrame.size),
          backgroundColor: style.backgroundColor,
          shadowColor: style.shadowColor,
          textColor: style.foregroundColor))
      addSubview(keyDownHintView!)
    }
  }

  // MARK: Top row key down hint view
  var isTopRow: Bool {
    // TODO: This is a quick & dirty hack
    return frame.origin.y < 15
  }

  func setTopRowKeyDownHintViewVisible(_ visible: Bool) {
    topRowKeyDownHintView?.removeFromSuperview()
    topRowKeyDownHintView = nil

    if visible {
      guard let style = style else { return }

      topRowKeyDownHintView = TopRowKeyDownHintView(
        keyFrame: keyBounds,
        keyLetter: textOrSymbol as? String ?? "",
        style: TopRowKeyDownHintViewStyle(
          font: style.font,
          cornerRadius: style.cornerRadius(keySize: keyFrame.size),
          backgroundColor: style.backgroundColor,
          shadowColor: style.shadowColor,
          textColor: style.foregroundColor),
        topExpansion: frame.origin.y,
        imageProvider: imageProvider)
      addSubview(topRowKeyDownHintView!)
    }
  }
}

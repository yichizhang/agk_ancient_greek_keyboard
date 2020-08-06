//
//  Created by Yichi Zhang on 19/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation
import UIKit

class BaseImageLabelView: UIView {
  fileprivate var frameWidthOfLastLayout = 0
  fileprivate var frameHeightOfLastLayout = 0

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

  override
  init(frame _: CGRect) {
    super.init(frame: CGRect.zero)
    commonBaseImageLabelViewInit()
  }

  required
  init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonBaseImageLabelViewInit()
  }

  func commonBaseImageLabelViewInit() {
    backgroundColor = UIColor.clear

    addSubview(backgroundImageView)
    addSubview(foregroundLabel)
    addSubview(foregroundImageView)
  }

  override
  func layoutSubviews() {
    super.layoutSubviews()

    let frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
    backgroundImageView.frame = frame
    foregroundImageView.frame = frame
    foregroundLabel.frame = frame

    if Int(frame.width) != frameWidthOfLastLayout &&
      Int(frame.height) != frameHeightOfLastLayout {
      frameDidChange()

      frameWidthOfLastLayout = Int(frame.width)
      frameHeightOfLastLayout = Int(frame.height)
    }
  }

  func frameDidChange() {
  }
}

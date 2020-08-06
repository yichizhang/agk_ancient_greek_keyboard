//
//  Created by Yichi Zhang on 18/07/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation
import UIKit

private struct KeyDownMenuViewPaddingFactor {
  static let x: CGFloat = 0.175
  static let y: CGFloat = 0.170
}

struct KeyDownMenuViewStyle {
  var font: UIFont!

  var cornerRadius: CGFloat!

  var backgroundColor: UIColor!
  var shadowColor: UIColor!
  var textColor: UIColor!
  var selectedTextColor: UIColor!

  var optionSize: CGSize!
  var superviewWidth: CGFloat!

  var interItemPadding: CGSize {
    let a = min(optionSize.width * KeyDownMenuViewPaddingFactor.x,
                optionSize.height * KeyDownMenuViewPaddingFactor.y)
    return CGSize(
      width: a,
      height: a)
  }

  var sidePadding: CGPoint {
    let a = min(optionSize.width * KeyDownMenuViewPaddingFactor.x,
                optionSize.height * KeyDownMenuViewPaddingFactor.y)
    return CGPoint(
      x: a,
      y: a)
  }
}

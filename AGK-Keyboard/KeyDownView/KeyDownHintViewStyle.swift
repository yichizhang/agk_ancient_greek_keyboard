//
//  Created by Yichi Zhang on 18/07/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

private struct KeyDownHintViewPaddingFactor {
  static let x: CGFloat = 0.375
  static let y: CGFloat = 0.075
}

struct KeyDownHintViewStyle {
  var font: UIFont!

  var cornerRadius: CGFloat!

  var backgroundColor: UIColor!
  var shadowColor: UIColor!
  var textColor: UIColor!

  func expandedKeySizeWithKeySize(_ keySize: CGSize) -> CGSize {
    return CGSize(
      width: keySize.width * (1 + 2 * KeyDownHintViewPaddingFactor.x),
      height: keySize.height * (1 + 2 * KeyDownHintViewPaddingFactor.y))
  }
}

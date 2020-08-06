//
//  Created by YICHI ZHANG on 11/04/2016.
//  Copyright (c) 2016 Yichi. All rights reserved.
//

import Foundation
import UIKit

enum KeyVisualArrangementOption {
  case widthRatioToRegular(ratio: CGFloat)

  case minWidth(amount: CGFloat)
  case exactWidth(amount: CGFloat)
  case maxWidth(amount: CGFloat)

  case flexGrow
}

class KeyVisualArrangement {
  var ID: String!
  var isSystemKey: Bool = false

  fileprivate(set) var hasRegularWidth: Bool = false
  fileprivate(set) var widthRatioToRegular: CGFloat?
  fileprivate(set) var minWidth: CGFloat?
  fileprivate(set) var exactWidth: CGFloat?
  fileprivate(set) var maxWidth: CGFloat?
  fileprivate(set) var isFlexGrow: Bool = false

  var frame: CGRect = CGRect.zero
  var inset: CGPoint = CGPoint.zero

  init(ID: String!,
       options: [KeyVisualArrangementOption]? = nil) {
    self.ID = ID

    guard let options = options
      , options.count > 0 else {
      hasRegularWidth = true
      return
    }

    for option in options {
      switch option
      {
      case let .widthRatioToRegular(ratio: widthRatio):
        widthRatioToRegular = widthRatio

      case let .minWidth(amount: minWidth):
        self.minWidth = minWidth

      case let .exactWidth(amount: exactWidth):
        self.exactWidth = exactWidth

      case let .maxWidth(amount: maxWidth):
        self.maxWidth = maxWidth

      case .flexGrow:
        isFlexGrow = true
      }
    }
  }
}

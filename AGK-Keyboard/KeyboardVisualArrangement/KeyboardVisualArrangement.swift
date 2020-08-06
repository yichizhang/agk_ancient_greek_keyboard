//
//  Created by YICHI ZHANG on 11/04/2016.
//  Copyright (c) 2016 Yichi. All rights reserved.
//

import Foundation
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

fileprivate func <= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

class KeyboardVisualArrangement {
  // Bounds for the keyboard view
  var bounds: CGRect!

  var keyButtonShapeInset: CGPoint!

  // Paddings
  var keyboardInset: UIEdgeInsets!

  // Preferred width for a regular key
  // This variable will be calculated automatically, unless you provide a positive value
  var regularKeyWidth: CGFloat!

  fileprivate
  var keyHeight: CGFloat!

  var keyArrangements: [KeyVisualArrangement]!

  fileprivate var keyArrangementRows: [KeyVisualArrangementRow]!

  init(
    bounds: CGRect,
    spaceInBetweenKeys: CGFloat!,
    spaceInBetweenRows: CGFloat!,
    keyboardInset: UIEdgeInsets!,
    regularKeyWidth: CGFloat = -1,
    keyArrangementRows: [KeyVisualArrangementRow]!) {
    self.bounds = bounds
    keyButtonShapeInset = CGPoint(x: spaceInBetweenKeys / 2, y: spaceInBetweenRows / 2)
    self.keyboardInset = keyboardInset
    self.regularKeyWidth = regularKeyWidth
    self.keyArrangementRows = keyArrangementRows

    calculate()
  }

  func calculate() {
    let availableWidth = bounds.width - keyboardInset.left - keyboardInset.right

    let rowCount = keyArrangementRows.count

    let availableHeight = bounds.height - keyboardInset.top - keyboardInset.bottom
    keyHeight = availableHeight / CGFloat(rowCount)

    // Prepare:
    if regularKeyWidth <= 0 {
      // The width of regular key needs to be minimal, so that keys on all rows can fit
      regularKeyWidth = CGFloat.greatestFiniteMagnitude

      for row in keyArrangementRows {
        var numberOfRegularKeys: CGFloat = 0
        var variableKeysWidthRatioSum: CGFloat = 0

        var numberOfVariableWithoutMinWidthKeys: CGFloat = 0
        var availableWidthExclMinWidths: CGFloat = availableWidth

        for key in row.keyArrangements {
          if key.hasRegularWidth {
            numberOfRegularKeys += 1

            continue
          }

          if let widthRatio = key.widthRatioToRegular {
            variableKeysWidthRatioSum += widthRatio

            if let minWidth = key.minWidth {
              availableWidthExclMinWidths -= minWidth
            } else {
              numberOfVariableWithoutMinWidthKeys += 1
            }
          }
        }

        let keyWidth: CGFloat = min(
          availableWidth / (numberOfRegularKeys + variableKeysWidthRatioSum),
          availableWidthExclMinWidths / (numberOfRegularKeys + numberOfVariableWithoutMinWidthKeys))

        if keyWidth < regularKeyWidth {
          regularKeyWidth = keyWidth
        }
      }
    }

    // Calculate and store layout:
    var originY = keyboardInset.top

    for row in keyArrangementRows {
      var flexGrowKeys: [KeyVisualArrangement] = []
      var remainingWidth = availableWidth

      // Calculate key widths
      for key in row.keyArrangements {
        key.frame.size.height = keyHeight

        if key.isFlexGrow {
          flexGrowKeys.append(key)

          continue
        }

        if key.hasRegularWidth {
          key.frame.size.width = regularKeyWidth
        }

        if let exactWidth = key.exactWidth {
          key.frame.size.width = exactWidth
        } else if let widthRatio = key.widthRatioToRegular {
          key.frame.size.width =
            max(
              key.minWidth ?? 0,
              min(
                regularKeyWidth * widthRatio,
                key.maxWidth ?? CGFloat.greatestFiniteMagnitude))
        }

        remainingWidth -= key.frame.size.width
      }

      let flexGrowKeysCount = CGFloat(flexGrowKeys.count)
      if flexGrowKeysCount > 0 {
        let flexibleKeyWidth = remainingWidth / CGFloat(flexGrowKeysCount)

        for key in flexGrowKeys {
          key.frame.size.width = flexibleKeyWidth
        }
      }

      // Put keys in correct order.
      for group in row.groups {
        var originX: CGFloat = 0

        for key in group.keyArrangements {
          key.frame.origin.x = originX
          key.frame.origin.y = originY

          originX += key.frame.size.width
        }

        group.width = originX
      }

      // MARK: Fix alignment
      var lastGroupLeadingEnd = keyboardInset.left
      var lastGroupTrailingEnd = bounds.size.width - keyboardInset.right
      for group in row.groups {
        var shiftAmount: CGFloat = 0

        switch group.alignment
        {
        case .leading:
          shiftAmount = lastGroupLeadingEnd
          lastGroupLeadingEnd += group.width
        case .trailing:
          shiftAmount = lastGroupTrailingEnd - group.width
          lastGroupTrailingEnd -= group.width
        default:
          shiftAmount = (bounds.size.width - group.width) * 0.5
        }

        for key in group.keyArrangements {
          key.frame.origin.x += shiftAmount
        }
      }

      originY += keyHeight
    }

    keyArrangements = keyArrangementRows.flatMap({ (row: KeyVisualArrangementRow) -> [KeyVisualArrangement] in
      row.keyArrangements
    })
  }
}

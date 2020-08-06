//
//  Created by Yichi Zhang on 18/07/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation
import UIKit

private extension CGRect {
  func containsX(_ x: CGFloat) -> Bool {
    return (x > minX && x < maxX)
  }

  func containsY(_ y: CGFloat) -> Bool {
    return (y > minY && y < maxY)
  }
}

class KeyDownMenuViewModel {
  fileprivate(set) var model: KeyDownMenuModel!
  fileprivate(set) weak var view: KeyDownMenuView?

  fileprivate(set) var selectedOption: String?
  var selectedOptionIndex: Int? {
    didSet {
      if let selectedOptionIndex = selectedOptionIndex {
        selectedOption = optionID(atIndex: selectedOptionIndex)
      } else {
        selectedOption = nil
      }
    }
  }

  lazy var defaultOptionIndex: Int? = { [unowned self] in
    if self.model.defaultOptionID == nil {
      return nil
    }

    var defaultOptionIndex: Int?
    for index in 0 ..< self.numberOfOptions {
      if self.model.defaultOptionID == self.optionID(atIndex: index) {
        defaultOptionIndex = index
        break
      }
    }
    return defaultOptionIndex
  }()

  var optionAlignment: KeyDownMenuOptionAlignment
  fileprivate(set) var numberOfOptions: Int = 0

  lazy var expandedKeySize: CGSize = { [unowned self] in
    self.createExpandedKeySize()
  }()

  lazy var optionRectArray: [CGRect] = { [unowned self] in
    self.createOptionRectArray()
  }()

  fileprivate var numberOfRows: Int = 0
  fileprivate var optionsPerRow: Int = 0

  fileprivate var padding: UIEdgeInsets = UIEdgeInsets.zero
  fileprivate var interItemSpacing: CGSize = CGSize.zero

  init(
    model: KeyDownMenuModel,
    view: KeyDownMenuView,
    optionAlignment: KeyDownMenuOptionAlignment) {
    numberOfOptions = model.options.count
    switch optionAlignment
    {
    case .grid:
      numberOfRows = 2
      optionsPerRow = Int(ceil(CGFloat(numberOfOptions) / CGFloat(numberOfRows)))

    case .horizontal:
      numberOfRows = 1
      optionsPerRow = numberOfOptions

    case .vertical:
      numberOfRows = numberOfOptions
      optionsPerRow = 1
    }

    let style = view.style
    let padding = style?.sidePadding
    self.padding = UIEdgeInsets(
      top: (padding?.y)!,
      left: (padding?.x)!,
      bottom: (padding?.y)!,
      right: (padding?.x)!)
    interItemSpacing = (style?.interItemPadding)!

    self.model = model
    self.view = view
    self.optionAlignment = optionAlignment
  }

  func displayStringForOptionAtIndex(_ index: Int) -> String {
    let option = model.options[index]
    return option.displayString ?? option.ID
  }

  func optionID(atIndex index: Int) -> String {
    return model.options[index].ID
  }

  func updateSelectionWithPoint(_ point: CGPoint) {
    let optionsPerRowf = CGFloat(optionsPerRow)

    for (i, optionRect) in optionRectArray.enumerated() {
      let iFloat = CGFloat(i)
      var isSelected = false

      switch optionAlignment
      {
      case .horizontal:
        isSelected = optionRect.containsX(point.x)

      case .vertical:
        isSelected = optionRect.containsY(point.y)

      case .grid:
        let xContained = optionRect.containsX(point.x)

        let row: Int = (iFloat >= optionsPerRowf) ? 1 : 0
        if row == 0 {
          isSelected = xContained && (point.y < optionRect.maxY)
        } else {
          isSelected = xContained && (point.y > optionRect.minY)
        }
      }

      if isSelected {
        selectedOptionIndex = i
        break
      }
    }
  }

  // MARK: Private

  fileprivate func createExpandedKeySize() -> CGSize {
    guard let view = self.view else { return CGSize.zero }

    let numf = CGFloat(numberOfOptions)

    var size = CGSize(
      width: padding.left + padding.right,
      height: padding.top + padding.bottom)
    let optionRectSize = view.style.optionSize

    switch optionAlignment
    {
    case .horizontal:
      size.width += (optionRectSize?.width)! * numf
      size.width += interItemSpacing.width * (numf - 1)
      size.height += (optionRectSize?.height)!
    case .vertical:
      size.width += (optionRectSize?.width)!
      size.height += (optionRectSize?.height)! * numf
      size.height += interItemSpacing.height * (numf - 1)
    case .grid:
      let numHf = CGFloat(optionsPerRow)
      let numVf = CGFloat(numberOfRows)
      size.width += (optionRectSize?.width)! * numHf
      size.width += interItemSpacing.width * (numHf - 1)
      size.height += (optionRectSize?.height)! * numVf
      size.height += interItemSpacing.height * (numVf - 1)
    }
    return size
  }

  fileprivate func createOptionRectArray() -> [CGRect] {
    guard let view = self.view else { return [] }

    let startOrig = view.keyDownPath.bounds.origin
    let optionsPerRowf = CGFloat(optionsPerRow)
    let optionRectSize = view.style.optionSize

    var ret: [CGRect] = []

    var offsetX = padding.left
    var offsetY = padding.top

    for i in 0 ..< numberOfOptions {
      var optionRect = CGRect(
        x: offsetX + startOrig.x,
        y: offsetY + startOrig.y,
        width: (optionRectSize?.width)!,
        height: (optionRectSize?.height)!)

      switch optionAlignment {
      case .horizontal:
        offsetX += (optionRectSize?.width)!
        offsetX += interItemSpacing.width
      case .vertical:
        offsetY += (optionRectSize?.height)!
        offsetY += interItemSpacing.height
      case .grid:
        let rowFloat: CGFloat!
        let colFloat: CGFloat!

        let indexf = CGFloat(i)
        if indexf >= optionsPerRowf {
          rowFloat = 1
          colFloat = indexf - optionsPerRowf
        } else {
          rowFloat = 0
          colFloat = indexf
        }

        optionRect.origin.x += colFloat * ((optionRectSize?.width)! + interItemSpacing.width)
        optionRect.origin.y += rowFloat * ((optionRectSize?.height)! + interItemSpacing.height)
      }

      ret.append(optionRect)
    }
    return ret
  }
}

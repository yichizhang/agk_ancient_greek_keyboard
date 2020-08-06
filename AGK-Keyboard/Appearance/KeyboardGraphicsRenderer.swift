//  Copyright (c) 2016-present Yichi Zhang. All rights reserved.

import Foundation
import UIKit

struct GraphicsRenderingDetails {

  var context: CGContext
  var rect: CGRect
  var foregroundColor: UIColor
  var backgroundColor: UIColor
}

protocol GraphicsRendererProtocol: class {
  func draw(_ d: GraphicsRenderingDetails)
}

class KeyboardGraphicsRenderer {
  class func drawTextAtCenterInRect(_ rect: CGRect, text: String, textColor: UIColor, textFont: UIFont) {
    var textRect = rect

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    let attributes = [
      NSAttributedString.Key.font: textFont,
      NSAttributedString.Key.foregroundColor: textColor,
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
    ]
    let textSize = (text as NSString).size(withAttributes: attributes)
    textRect.origin.y += (textRect.height - textSize.height) / 2

    let attributedString = NSAttributedString(string: text, attributes: attributes)
    attributedString.draw(in: textRect)
  }
}

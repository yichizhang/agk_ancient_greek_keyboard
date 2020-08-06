//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class KeyBackgroundGraphics {
  class func drawInContext(
    _ context: CGContext,
    keyFrame: CGRect,
    cornerRadius: CGFloat,
    keyColor: UIColor,
    keyShadowColor: UIColor) {
    let shadowOffset = CGSize(width: 0.1, height: 1.1)
    let shadowBlurRadius: CGFloat = 0

    let roundedRectPath = UIBezierPath(roundedRect: keyFrame, cornerRadius: cornerRadius)

    context.saveGState()
    context.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: keyShadowColor.cgColor)
    keyColor.setFill()
    roundedRectPath.fill()
    context.restoreGState()
  }
}

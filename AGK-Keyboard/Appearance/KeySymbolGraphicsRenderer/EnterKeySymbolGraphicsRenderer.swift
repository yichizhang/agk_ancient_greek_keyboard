//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class EnterKeySymbolGraphicsRenderer: GraphicsRendererProtocol {

  func draw(_ d: GraphicsRenderingDetails) {
    // Size of canvas
    let size = CGSize(width: 24, height: 24)

    d.context.saveGState()
    d.context.translateBy(x: (d.rect.width - size.width) / 2, y: (d.rect.height - size.height) / 2)

    //// Color Declarations
    let fillColor = d.foregroundColor

    //// Page-1
    //// Enter 4
    //// Group 5
    //// Rectangle-101 Drawing
    let rectangle101Path = UIBezierPath()
    rectangle101Path.move(to: CGPoint(x: 21.86, y: 5.02))
    rectangle101Path.addCurve(to: CGPoint(x: 22.86, y: 6.02), controlPoint1: CGPoint(x: 22.41, y: 5.02), controlPoint2: CGPoint(x: 22.86, y: 5.47))
    rectangle101Path.addLine(to: CGPoint(x: 22.85, y: 13.38))
    rectangle101Path.addCurve(to: CGPoint(x: 21.85, y: 14.38), controlPoint1: CGPoint(x: 22.84, y: 13.93), controlPoint2: CGPoint(x: 22.4, y: 14.38))
    rectangle101Path.addLine(to: CGPoint(x: 3.4, y: 14.38))
    rectangle101Path.addLine(to: CGPoint(x: 8.34, y: 18.54))
    rectangle101Path.addLine(to: CGPoint(x: 7.66, y: 19.35))
    rectangle101Path.addLine(to: CGPoint(x: 1, y: 13.85))
    rectangle101Path.addLine(to: CGPoint(x: 7.66, y: 8.35))
    rectangle101Path.addLine(to: CGPoint(x: 8.34, y: 9.16))
    rectangle101Path.addLine(to: CGPoint(x: 3.4, y: 13.32))
    rectangle101Path.addLine(to: CGPoint(x: 21.48, y: 13.32))
    rectangle101Path.addCurve(to: CGPoint(x: 21.78, y: 13.03), controlPoint1: CGPoint(x: 21.65, y: 13.32), controlPoint2: CGPoint(x: 21.78, y: 13.19))
    rectangle101Path.addLine(to: CGPoint(x: 21.78, y: 6.37))
    rectangle101Path.addCurve(to: CGPoint(x: 21.49, y: 6.07), controlPoint1: CGPoint(x: 21.78, y: 6.21), controlPoint2: CGPoint(x: 21.66, y: 6.07))
    rectangle101Path.addLine(to: CGPoint(x: 16.26, y: 6.07))
    rectangle101Path.addCurve(to: CGPoint(x: 15.77, y: 5.57), controlPoint1: CGPoint(x: 15.99, y: 6.07), controlPoint2: CGPoint(x: 15.77, y: 5.85))
    rectangle101Path.addLine(to: CGPoint(x: 15.77, y: 5.5))
    rectangle101Path.addCurve(to: CGPoint(x: 16.27, y: 5), controlPoint1: CGPoint(x: 15.77, y: 5.22), controlPoint2: CGPoint(x: 15.99, y: 5))
    rectangle101Path.addLine(to: CGPoint(x: 21.86, y: 5.02))
    rectangle101Path.close()
    rectangle101Path.miterLimit = 4

    rectangle101Path.usesEvenOddFillRule = true

    fillColor.setFill()
    rectangle101Path.fill()

    d.context.restoreGState()
  }
}

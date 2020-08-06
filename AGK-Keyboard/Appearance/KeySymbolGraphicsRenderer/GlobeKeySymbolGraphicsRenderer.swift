//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class GlobeKeySymbolGraphicsRenderer: GraphicsRendererProtocol {

  func draw(_ d: GraphicsRenderingDetails) {
    // Size of canvas
    let size = CGSize(width: 24, height: 24)

    d.context.saveGState()
    d.context.translateBy(x: (d.rect.width - size.width) / 2, y: (d.rect.height - size.height) / 2)

    //// Color Declarations
    let strokeColor = d.foregroundColor

    //// Page-1
    //// Globe 3
    //// icon
    //// Oval-1 Drawing
    let oval1Path = UIBezierPath()
    oval1Path.move(to: CGPoint(x: 12, y: 20.5))
    oval1Path.addCurve(to: CGPoint(x: 17.89, y: 18.13), controlPoint1: CGPoint(x: 14.28, y: 20.5), controlPoint2: CGPoint(x: 16.36, y: 19.6))
    oval1Path.addCurve(to: CGPoint(x: 20.5, y: 12), controlPoint1: CGPoint(x: 19.5, y: 16.58), controlPoint2: CGPoint(x: 20.5, y: 14.41))
    oval1Path.addCurve(to: CGPoint(x: 12, y: 3.5), controlPoint1: CGPoint(x: 20.5, y: 7.31), controlPoint2: CGPoint(x: 16.69, y: 3.5))
    oval1Path.addCurve(to: CGPoint(x: 3.5, y: 12), controlPoint1: CGPoint(x: 7.31, y: 3.5), controlPoint2: CGPoint(x: 3.5, y: 7.31))
    oval1Path.addCurve(to: CGPoint(x: 12, y: 20.5), controlPoint1: CGPoint(x: 3.5, y: 16.69), controlPoint2: CGPoint(x: 7.31, y: 20.5))
    oval1Path.close()
    oval1Path.miterLimit = 4

    oval1Path.usesEvenOddFillRule = true

    strokeColor.setStroke()
    oval1Path.lineWidth = 1
    oval1Path.stroke()

    //// Oval-2 Drawing
    let oval2Path = UIBezierPath(ovalIn: CGRect(x: 7.5, y: 3.5, width: 9, height: 17))
    strokeColor.setStroke()
    oval2Path.lineWidth = 1
    oval2Path.stroke()

    //// Line Drawing
    let linePath = UIBezierPath()
    linePath.move(to: CGPoint(x: 3.69, y: 11.99))
    linePath.addLine(to: CGPoint(x: 20, y: 11.99))
    linePath.miterLimit = 4

    linePath.lineCapStyle = .square

    linePath.usesEvenOddFillRule = true

    strokeColor.setStroke()
    linePath.lineWidth = 1
    linePath.stroke()

    //// Line 2 Drawing
    let line2Path = UIBezierPath()
    line2Path.move(to: CGPoint(x: 12, y: 4))
    line2Path.addLine(to: CGPoint(x: 12, y: 20))
    line2Path.miterLimit = 4

    line2Path.lineCapStyle = .square

    line2Path.usesEvenOddFillRule = true

    strokeColor.setStroke()
    line2Path.lineWidth = 1
    line2Path.stroke()

    //// Oval-4 Drawing
    let oval4Path = UIBezierPath()
    oval4Path.move(to: CGPoint(x: 6.5, y: 5.73))
    oval4Path.addCurve(to: CGPoint(x: 11.91, y: 8.5), controlPoint1: CGPoint(x: 7.9, y: 7.44), controlPoint2: CGPoint(x: 9.81, y: 8.5))
    oval4Path.addCurve(to: CGPoint(x: 17.5, y: 5.5), controlPoint1: CGPoint(x: 14.1, y: 8.5), controlPoint2: CGPoint(x: 16.09, y: 7.35))
    oval4Path.miterLimit = 4

    oval4Path.usesEvenOddFillRule = true

    strokeColor.setStroke()
    oval4Path.lineWidth = 1
    oval4Path.stroke()

    //// Oval-5 Drawing
    let oval5Path = UIBezierPath()
    oval5Path.move(to: CGPoint(x: 17.5, y: 18.27))
    oval5Path.addCurve(to: CGPoint(x: 12.09, y: 15.5), controlPoint1: CGPoint(x: 16.1, y: 16.56), controlPoint2: CGPoint(x: 14.19, y: 15.5))
    oval5Path.addCurve(to: CGPoint(x: 6.5, y: 18.5), controlPoint1: CGPoint(x: 9.9, y: 15.5), controlPoint2: CGPoint(x: 7.91, y: 16.65))
    oval5Path.miterLimit = 4

    oval5Path.usesEvenOddFillRule = true

    strokeColor.setStroke()
    oval5Path.lineWidth = 1
    oval5Path.stroke()

    d.context.restoreGState()
  }
}

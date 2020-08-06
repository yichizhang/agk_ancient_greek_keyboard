//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class CapsLockKeySymbolGraphicsRenderer: GraphicsRendererProtocol {

  func draw(_ d: GraphicsRenderingDetails) {
    // Size of canvas
    let size = CGSize(width: 24, height: 24)

    d.context.saveGState()
    d.context.translateBy(x: (d.rect.width - size.width) / 2, y: (d.rect.height - size.height) / 2)

    //// Color Declarations
    let fillColor = d.foregroundColor

    //// Page-1
    //// CapsLock-Arrow
    //// Group- 5
    //// Imported-Layers Drawing
    let importedLayersPath = UIBezierPath()
    importedLayersPath.move(to: CGPoint(x: 12.38, y: 3.21))
    importedLayersPath.addCurve(to: CGPoint(x: 11.37, y: 3.21), controlPoint1: CGPoint(x: 12.1, y: 2.93), controlPoint2: CGPoint(x: 11.65, y: 2.93))
    importedLayersPath.addLine(to: CGPoint(x: 3.17, y: 11.32))
    importedLayersPath.addCurve(to: CGPoint(x: 3.59, y: 12.32), controlPoint1: CGPoint(x: 2.8, y: 11.69), controlPoint2: CGPoint(x: 3.07, y: 12.32))
    importedLayersPath.addLine(to: CGPoint(x: 7.61, y: 12.32))
    importedLayersPath.addLine(to: CGPoint(x: 7.61, y: 16.54))
    importedLayersPath.addCurve(to: CGPoint(x: 9.03, y: 17.94), controlPoint1: CGPoint(x: 7.61, y: 17.31), controlPoint2: CGPoint(x: 8.25, y: 17.94))
    importedLayersPath.addLine(to: CGPoint(x: 14.72, y: 17.94))
    importedLayersPath.addCurve(to: CGPoint(x: 16.14, y: 16.54), controlPoint1: CGPoint(x: 15.5, y: 17.94), controlPoint2: CGPoint(x: 16.14, y: 17.31))
    importedLayersPath.addLine(to: CGPoint(x: 16.14, y: 12.32))
    importedLayersPath.addLine(to: CGPoint(x: 20.16, y: 12.32))
    importedLayersPath.addCurve(to: CGPoint(x: 20.57, y: 11.32), controlPoint1: CGPoint(x: 20.68, y: 12.32), controlPoint2: CGPoint(x: 20.95, y: 11.69))
    importedLayersPath.addLine(to: CGPoint(x: 12.38, y: 3.21))
    importedLayersPath.close()
    importedLayersPath.miterLimit = 4

    importedLayersPath.usesEvenOddFillRule = true

    fillColor.setFill()
    importedLayersPath.fill()

    //// Rectangle 2 Drawing
    let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: 7.65, y: 19.5, width: 8.5, height: 2), cornerRadius: 1)
    fillColor.setFill()
    rectangle2Path.fill()

    d.context.restoreGState()
  }
}

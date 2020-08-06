//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class ShiftKeySymbolGraphicsRenderer: GraphicsRendererProtocol {

  func draw(_ d: GraphicsRenderingDetails) {
    // Size of canvas
    let size = CGSize(width: 24, height: 24)

    d.context.saveGState()
    d.context.translateBy(x: (d.rect.width - size.width) / 2, y: (d.rect.height - size.height) / 2)

    drawOutline(fg: d.foregroundColor)

    d.context.restoreGState()
  }

  private func drawSolid(fg: UIColor) {
    //// Color Declarations
    let fillColor = fg

    //// Page-1
    //// Shift-Arrow
    //// Imported-Layers Drawing
    let importedLayersPath = UIBezierPath()
    importedLayersPath.move(to: CGPoint(x: 12.38, y: 4.21))
    importedLayersPath.addCurve(to: CGPoint(x: 11.37, y: 4.21), controlPoint1: CGPoint(x: 12.1, y: 3.93), controlPoint2: CGPoint(x: 11.65, y: 3.93))
    importedLayersPath.addLine(to: CGPoint(x: 3.17, y: 12.32))
    importedLayersPath.addCurve(to: CGPoint(x: 3.59, y: 13.32), controlPoint1: CGPoint(x: 2.8, y: 12.69), controlPoint2: CGPoint(x: 3.07, y: 13.32))
    importedLayersPath.addLine(to: CGPoint(x: 7.61, y: 13.32))
    importedLayersPath.addLine(to: CGPoint(x: 7.61, y: 17.54))
    importedLayersPath.addCurve(to: CGPoint(x: 9.03, y: 18.94), controlPoint1: CGPoint(x: 7.61, y: 18.31), controlPoint2: CGPoint(x: 8.25, y: 18.94))
    importedLayersPath.addLine(to: CGPoint(x: 14.72, y: 18.94))
    importedLayersPath.addCurve(to: CGPoint(x: 16.14, y: 17.54), controlPoint1: CGPoint(x: 15.5, y: 18.94), controlPoint2: CGPoint(x: 16.14, y: 18.31))
    importedLayersPath.addLine(to: CGPoint(x: 16.14, y: 13.32))
    importedLayersPath.addLine(to: CGPoint(x: 20.16, y: 13.32))
    importedLayersPath.addCurve(to: CGPoint(x: 20.57, y: 12.32), controlPoint1: CGPoint(x: 20.68, y: 13.32), controlPoint2: CGPoint(x: 20.95, y: 12.69))
    importedLayersPath.addLine(to: CGPoint(x: 12.38, y: 4.21))
    importedLayersPath.close()
    importedLayersPath.miterLimit = 4

    importedLayersPath.usesEvenOddFillRule = true

    fillColor.setFill()
    importedLayersPath.fill()
  }

  private func drawOutline(fg: UIColor) {
    //// Color Declarations
    let fillColor = fg

    //// Page-1
    //// Shift-Arrow-Outline
    //// Shape Drawing
    let shapePath = UIBezierPath()
    shapePath.move(to: CGPoint(x: 8.26, y: 14.57))
    shapePath.addLine(to: CGPoint(x: 3.99, y: 14.57))
    shapePath.addCurve(to: CGPoint(x: 3.15, y: 12.6), controlPoint1: CGPoint(x: 2.49, y: 14.57), controlPoint2: CGPoint(x: 3.13, y: 12.63))
    shapePath.addLine(to: CGPoint(x: 11.07, y: 4.3))
    shapePath.addCurve(to: CGPoint(x: 12.45, y: 4.3), controlPoint1: CGPoint(x: 11.45, y: 3.9), controlPoint2: CGPoint(x: 12.06, y: 3.9))
    shapePath.addLine(to: CGPoint(x: 20.35, y: 12.6))
    shapePath.addCurve(to: CGPoint(x: 19.5, y: 14.57), controlPoint1: CGPoint(x: 21.38, y: 13.69), controlPoint2: CGPoint(x: 19.53, y: 14.57))
    shapePath.addLine(to: CGPoint(x: 15.24, y: 14.57))
    shapePath.addLine(to: CGPoint(x: 16.4, y: 13.41))
    shapePath.addLine(to: CGPoint(x: 16.4, y: 18.39))
    shapePath.addCurve(to: CGPoint(x: 14.41, y: 20.39), controlPoint1: CGPoint(x: 16.4, y: 19.49), controlPoint2: CGPoint(x: 15.51, y: 20.39))
    shapePath.addLine(to: CGPoint(x: 9.09, y: 20.39))
    shapePath.addCurve(to: CGPoint(x: 7.1, y: 18.39), controlPoint1: CGPoint(x: 7.99, y: 20.39), controlPoint2: CGPoint(x: 7.1, y: 19.49))
    shapePath.addLine(to: CGPoint(x: 7.1, y: 13.41))
    shapePath.addLine(to: CGPoint(x: 8.26, y: 14.57))
    shapePath.close()
    shapePath.move(to: CGPoint(x: 8.26, y: 13.41))
    shapePath.addLine(to: CGPoint(x: 8.26, y: 18.22))
    shapePath.addCurve(to: CGPoint(x: 9.26, y: 19.22), controlPoint1: CGPoint(x: 8.26, y: 18.77), controlPoint2: CGPoint(x: 8.71, y: 19.22))
    shapePath.addLine(to: CGPoint(x: 14.24, y: 19.22))
    shapePath.addCurve(to: CGPoint(x: 15.24, y: 18.22), controlPoint1: CGPoint(x: 14.79, y: 19.22), controlPoint2: CGPoint(x: 15.24, y: 18.77))
    shapePath.addLine(to: CGPoint(x: 15.24, y: 13.41))
    shapePath.addLine(to: CGPoint(x: 19, y: 13.41))
    shapePath.addCurve(to: CGPoint(x: 19.16, y: 13.05), controlPoint1: CGPoint(x: 19.28, y: 13.41), controlPoint2: CGPoint(x: 19.36, y: 13.25))
    shapePath.addLine(to: CGPoint(x: 11.76, y: 5.26))
    shapePath.addLine(to: CGPoint(x: 4.34, y: 13.05))
    shapePath.addCurve(to: CGPoint(x: 4.5, y: 13.41), controlPoint1: CGPoint(x: 4.15, y: 13.25), controlPoint2: CGPoint(x: 4.22, y: 13.41))
    shapePath.addLine(to: CGPoint(x: 8.26, y: 13.41))
    shapePath.close()
    shapePath.miterLimit = 4

    fillColor.setFill()
    shapePath.fill()
  }
}

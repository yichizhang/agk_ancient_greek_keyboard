//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class DeleteKeySymbolGraphicsRenderer: GraphicsRendererProtocol {

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
    //// Delete 2
    //// Imported-Layers Drawing
    let importedLayersPath = UIBezierPath()
    importedLayersPath.move(to: CGPoint(x: 18.16, y: 5))
    importedLayersPath.addLine(to: CGPoint(x: 9.86, y: 5))
    importedLayersPath.addCurve(to: CGPoint(x: 7.7, y: 5.89), controlPoint1: CGPoint(x: 9.05, y: 5), controlPoint2: CGPoint(x: 8.28, y: 5.32))
    importedLayersPath.addLine(to: CGPoint(x: 2.25, y: 11.34))
    importedLayersPath.addCurve(to: CGPoint(x: 2.25, y: 12.57), controlPoint1: CGPoint(x: 1.92, y: 11.68), controlPoint2: CGPoint(x: 1.92, y: 12.23))
    importedLayersPath.addLine(to: CGPoint(x: 7.7, y: 18.02))
    importedLayersPath.addCurve(to: CGPoint(x: 9.86, y: 18.91), controlPoint1: CGPoint(x: 8.28, y: 18.59), controlPoint2: CGPoint(x: 9.05, y: 18.91))
    importedLayersPath.addLine(to: CGPoint(x: 18.16, y: 18.91))
    importedLayersPath.addCurve(to: CGPoint(x: 21.21, y: 15.87), controlPoint1: CGPoint(x: 19.84, y: 18.91), controlPoint2: CGPoint(x: 21.21, y: 17.55))
    importedLayersPath.addLine(to: CGPoint(x: 21.21, y: 8.04))
    importedLayersPath.addCurve(to: CGPoint(x: 18.16, y: 5), controlPoint1: CGPoint(x: 21.21, y: 6.36), controlPoint2: CGPoint(x: 19.84, y: 5))
    importedLayersPath.addLine(to: CGPoint(x: 18.16, y: 5))
    importedLayersPath.close()
    importedLayersPath.move(to: CGPoint(x: 17.35, y: 14.57))
    importedLayersPath.addLine(to: CGPoint(x: 16.43, y: 15.49))
    importedLayersPath.addLine(to: CGPoint(x: 13.81, y: 12.88))
    importedLayersPath.addLine(to: CGPoint(x: 11.2, y: 15.49))
    importedLayersPath.addLine(to: CGPoint(x: 10.28, y: 14.57))
    importedLayersPath.addLine(to: CGPoint(x: 12.89, y: 11.96))
    importedLayersPath.addLine(to: CGPoint(x: 10.28, y: 9.34))
    importedLayersPath.addLine(to: CGPoint(x: 11.2, y: 8.42))
    importedLayersPath.addLine(to: CGPoint(x: 13.81, y: 11.03))
    importedLayersPath.addLine(to: CGPoint(x: 16.43, y: 8.42))
    importedLayersPath.addLine(to: CGPoint(x: 17.35, y: 9.34))
    importedLayersPath.addLine(to: CGPoint(x: 14.74, y: 11.96))
    importedLayersPath.addLine(to: CGPoint(x: 17.35, y: 14.57))
    importedLayersPath.addLine(to: CGPoint(x: 17.35, y: 14.57))
    importedLayersPath.close()
    importedLayersPath.miterLimit = 4

    importedLayersPath.usesEvenOddFillRule = true

    fillColor.setFill()
    importedLayersPath.fill()
  }

  private func drawOutline(fg: UIColor) {
    //// Color Declarations
    let strokeColor = fg
    let fillColor = fg

    //// Page-1
    //// Delete-Outline-Alt
    //// Group 5
    //// Shape Drawing
    let shapePath = UIBezierPath()
    shapePath.move(to: CGPoint(x: 13.5, y: 11.22))
    shapePath.addLine(to: CGPoint(x: 11.26, y: 8.98))
    shapePath.addCurve(to: CGPoint(x: 10.55, y: 8.98), controlPoint1: CGPoint(x: 11.06, y: 8.79), controlPoint2: CGPoint(x: 10.75, y: 8.79))
    shapePath.addCurve(to: CGPoint(x: 10.55, y: 9.69), controlPoint1: CGPoint(x: 10.36, y: 9.17), controlPoint2: CGPoint(x: 10.35, y: 9.49))
    shapePath.addLine(to: CGPoint(x: 12.79, y: 11.93))
    shapePath.addLine(to: CGPoint(x: 10.55, y: 14.17))
    shapePath.addCurve(to: CGPoint(x: 10.55, y: 14.88), controlPoint1: CGPoint(x: 10.36, y: 14.36), controlPoint2: CGPoint(x: 10.36, y: 14.68))
    shapePath.addCurve(to: CGPoint(x: 11.26, y: 14.88), controlPoint1: CGPoint(x: 10.74, y: 15.06), controlPoint2: CGPoint(x: 11.06, y: 15.07))
    shapePath.addLine(to: CGPoint(x: 13.5, y: 12.64))
    shapePath.addLine(to: CGPoint(x: 15.74, y: 14.88))
    shapePath.addCurve(to: CGPoint(x: 16.44, y: 14.88), controlPoint1: CGPoint(x: 15.93, y: 15.07), controlPoint2: CGPoint(x: 16.25, y: 15.07))
    shapePath.addCurve(to: CGPoint(x: 16.45, y: 14.17), controlPoint1: CGPoint(x: 16.63, y: 14.69), controlPoint2: CGPoint(x: 16.64, y: 14.36))
    shapePath.addLine(to: CGPoint(x: 14.2, y: 11.93))
    shapePath.addLine(to: CGPoint(x: 16.45, y: 9.69))
    shapePath.addCurve(to: CGPoint(x: 16.44, y: 8.98), controlPoint1: CGPoint(x: 16.64, y: 9.49), controlPoint2: CGPoint(x: 16.64, y: 9.18))
    shapePath.addCurve(to: CGPoint(x: 15.74, y: 8.98), controlPoint1: CGPoint(x: 16.25, y: 8.79), controlPoint2: CGPoint(x: 15.93, y: 8.79))
    shapePath.addLine(to: CGPoint(x: 13.5, y: 11.22))
    shapePath.close()
    shapePath.miterLimit = 4

    fillColor.setFill()
    shapePath.fill()

    //// Rectangle-10 Drawing
    let rectangle10Path = UIBezierPath()
    rectangle10Path.move(to: CGPoint(x: 9.39, y: 5))
    rectangle10Path.addLine(to: CGPoint(x: 17.22, y: 5))
    rectangle10Path.addLine(to: CGPoint(x: 17.22, y: 5))
    rectangle10Path.addCurve(to: CGPoint(x: 21.22, y: 9), controlPoint1: CGPoint(x: 19.43, y: 5), controlPoint2: CGPoint(x: 21.22, y: 6.79))
    rectangle10Path.addLine(to: CGPoint(x: 21.22, y: 15))
    rectangle10Path.addLine(to: CGPoint(x: 21.22, y: 15))
    rectangle10Path.addCurve(to: CGPoint(x: 17.22, y: 19), controlPoint1: CGPoint(x: 21.22, y: 17.21), controlPoint2: CGPoint(x: 19.43, y: 19))
    rectangle10Path.addLine(to: CGPoint(x: 9.39, y: 19))
    rectangle10Path.addLine(to: CGPoint(x: 9.39, y: 19))
    rectangle10Path.addCurve(to: CGPoint(x: 7.97, y: 18.41), controlPoint1: CGPoint(x: 8.86, y: 19), controlPoint2: CGPoint(x: 8.35, y: 18.79))
    rectangle10Path.addLine(to: CGPoint(x: 2.29, y: 12.71))
    rectangle10Path.addLine(to: CGPoint(x: 2.29, y: 12.71))
    rectangle10Path.addCurve(to: CGPoint(x: 2.29, y: 11.29), controlPoint1: CGPoint(x: 1.9, y: 12.32), controlPoint2: CGPoint(x: 1.9, y: 11.68))
    rectangle10Path.addLine(to: CGPoint(x: 7.97, y: 5.59))
    rectangle10Path.addLine(to: CGPoint(x: 7.97, y: 5.59))
    rectangle10Path.addCurve(to: CGPoint(x: 9.39, y: 5), controlPoint1: CGPoint(x: 8.35, y: 5.21), controlPoint2: CGPoint(x: 8.86, y: 5))
    rectangle10Path.close()
    rectangle10Path.miterLimit = 4

    rectangle10Path.usesEvenOddFillRule = true

    strokeColor.setStroke()
    rectangle10Path.lineWidth = 1
    rectangle10Path.stroke()
  }
}

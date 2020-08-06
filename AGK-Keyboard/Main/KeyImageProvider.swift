//  Copyright (c) 2016-present Yichi Zhang. All rights reserved.

import Foundation

class KeyImageProvider {
  fileprivate static var cache: [String: UIImage?] = [:]
  fileprivate static var symbolRendererMapping: [SystemKeySymbol: GraphicsRendererProtocol] = {
    [
      .shift: ShiftKeySymbolGraphicsRenderer(),
      .capsLock: CapsLockKeySymbolGraphicsRenderer(),
      .delete: DeleteKeySymbolGraphicsRenderer(),
      .globe: GlobeKeySymbolGraphicsRenderer(),
      .enter: EnterKeySymbolGraphicsRenderer(),
    ]
  }()

  func keyImage(buttonBounds: CGRect,
                keyFrame: CGRect,
                cornerRadius: CGFloat,
                keyColor: UIColor,
                keyShadowColor: UIColor) -> UIImage? {
    let cacheKey = "keyImage \(buttonBounds.size.desc) \(Int(cornerRadius)) \(keyColor.hexString) \(keyShadowColor.hexString)"

    if let image = KeyImageProvider.cache[cacheKey] {
      D.logVerbose("keyImage - cache hit - key=\(cacheKey)")
      return image
    }

    D.logVerbose("keyImage - cache miss - key=\(cacheKey)")
    let image = UIImage.createImageOfSize(
      buttonBounds.size,
      usingBlock: { context in
        KeyBackgroundGraphics.drawInContext(
          context,
          keyFrame: keyFrame,
          cornerRadius: cornerRadius,
          keyColor: keyColor,
          keyShadowColor: keyShadowColor)
    })
    KeyImageProvider.cache[cacheKey] = image

    return image
  }

  func symbolImage(
    _ symbol: SystemKeySymbol,
    rect: CGRect,
    foregroundColor: UIColor,
    backgroundColor: UIColor) -> UIImage? {
    
    let cacheKey = "symbolImage \(symbol.rawValue) \(rect.size.desc) \(foregroundColor.hexString) \(backgroundColor.hexString)"

    if let image = KeyImageProvider.cache[cacheKey] {
      D.logVerbose("symbolImage - cache hit - key=\(cacheKey)")
      return image
    }

    D.logVerbose("symbolImage - cache miss - key=\(cacheKey)")
    let image = UIImage.createImageOfSize(
      rect.size,
      usingBlock: { context in
        if let renderer = KeyImageProvider.symbolRendererMapping[symbol] {
          renderer.draw(GraphicsRenderingDetails(
            context: context,
            rect: rect,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor
          ))
        }
    })
    KeyImageProvider.cache[cacheKey] = image

    return image
  }
}

//
//  Created by Yichi Zhang on 21/08/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

typealias TextStyle = UIFont.TextStyle
typealias TextAttributes = [NSAttributedString.Key: Any]

extension String {
  
  func styled(with style: TextStyle, maxSizeFactor: CGFloat? = nil, isBold: Bool = false) -> NSAttributedString {
    return NSAttributedString(string: self, attributes: style.attributes(maxSizeFactor: maxSizeFactor, isBold: isBold))
  }
}

extension TextStyle {
  var fgColor: UIColor {
    return UIColor.black
  }
  
  var font: UIFont {
    return font(maxSizeFactor: CGFloat.greatestFiniteMagnitude)
  }
  
  var attributes: [NSAttributedString.Key: Any] {
    return [
      NSAttributedString.Key.foregroundColor: fgColor,
      NSAttributedString.Key.font: font,
    ]
  }

  func font(maxSizeFactor: CGFloat? = nil, isBold: Bool = false) -> UIFont {
    let size: CGFloat
      
    let maxSizeFactor = maxSizeFactor ?? CGFloat.greatestFiniteMagnitude
    size = pointSize * min(maxSizeFactor, sizeFactor)
    
    return isBold ?
      UIFont.boldSystemFont(ofSize: size) :
      UIFont.systemFont(ofSize: size)
  }
  
  func attributes(maxSizeFactor: CGFloat? = nil, isBold: Bool = false, additionalAttributes: TextAttributes? = nil) -> TextAttributes {
    
    var ret: TextAttributes = additionalAttributes ?? [:]
    ret[NSAttributedString.Key.foregroundColor] = fgColor
    ret[NSAttributedString.Key.font] = font(maxSizeFactor: maxSizeFactor, isBold: isBold)
    return ret
  }
}

fileprivate extension TextStyle {
  var pointSize: CGFloat {
    switch self {
    case .largeTitle: return 30.0
    case .title1: return 28.0
    case .title2: return 22.0
    case .title3: return 20.0
    case .headline: return 17.0
    case .subheadline: return 15.0
    case .body: return 17.0
    case .callout: return 16.0
    case .footnote: return 13.0
    case .caption1: return 12.0
    case .caption2: return 11.0
    default: return 12.0
    }
  }
}

fileprivate extension TextStyle {
  var sizeFactor: CGFloat {
    switch UIApplication.shared.preferredContentSizeCategory {
    case UIContentSizeCategory.extraSmall: return 0.87
    case UIContentSizeCategory.small: return 0.94
    case UIContentSizeCategory.medium: return 1.00
    case UIContentSizeCategory.large: return 1.06
    case UIContentSizeCategory.extraLarge: return 1.19
    case UIContentSizeCategory.extraExtraLarge: return 1.30
    case UIContentSizeCategory.extraExtraExtraLarge: return 1.43
    case UIContentSizeCategory.accessibilityMedium: return 1.75
    case UIContentSizeCategory.accessibilityLarge: return 2.06
    case UIContentSizeCategory.accessibilityExtraLarge: return 2.50
    case UIContentSizeCategory.accessibilityExtraExtraLarge: return 2.95
    case UIContentSizeCategory.accessibilityExtraExtraExtraLarge: return 3.32
    default: return 1.0
    }
  }
}

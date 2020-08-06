//
//  Created by Yichi Zhang on 2017-02-22.
//  Copyright (c) 2017-present Yichi. All rights reserved.
//

import Foundation

extension UIFont {
  class func yz_create(
    family: String,
    weight weightString: String = KeyboardFontWeight.Regular,
    size: CGFloat
  ) -> UIFont! {
    let isBold: Bool = (weightString == KeyboardFontWeight.Bold)

    if UIFont.fontNames(forFamilyName: family).count > 0 {
      let weight = isBold ? UIFont.Weight.bold : UIFont.Weight.regular
      let fd = UIFontDescriptor(fontAttributes: [
        UIFontDescriptor.AttributeName.family: family,
        UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: weight],
      ])
      return UIFont(descriptor: fd, size: size)
    }

    return isBold ?
      UIFont.boldSystemFont(ofSize: size) :
      UIFont.systemFont(ofSize: size)
  }

  class func yz_create(
    family: String,
    weight weightString: String = KeyboardFontWeight.Regular,
    style: UIFont.TextStyle
  ) -> UIFont! {
    let sizeFD = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)

    return yz_create(
      family: family,
      weight: weightString,
      size: sizeFD.pointSize)
  }
}

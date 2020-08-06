//
//  Created by Yichi Zhang on 20/06/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation
import UIKit

protocol FontStyleDelegate: class {
  func fontNameForFontStyle(_ style: FontStyle) -> String?
  func prefersBoldForFontStyle(_ style: FontStyle) -> Bool
}

class FontStyle {
  weak var delegate: FontStyleDelegate?
  var size: CGFloat

  var font: UIFont {
    if let
      fontName = delegate?.fontNameForFontStyle(self),
      let font = UIFont(name: fontName, size: size) {
      return font
    }

    if delegate?.prefersBoldForFontStyle(self) == true {
      return UIFont.boldSystemFont(ofSize: size)
    }
    return UIFont.systemFont(ofSize: size)
  }

  init(delegate: FontStyleDelegate, size: CGFloat) {
    self.delegate = delegate
    self.size = size
  }
}

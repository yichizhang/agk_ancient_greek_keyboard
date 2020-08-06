//
//  Created by Yichi Zhang on 20/06/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class KeyboardTextStyle: FontStyleDelegate {
  var mainFontName: String?
  var prefersBoldMainFont: Bool = false

  var keyText: FontStyle!
  var systemKeyText: FontStyle!
  var nextKeyboardMenu: FontStyle!

  var keyDownView: FontStyle!
  var keyDownInputOptionText: FontStyle!

  var extraInputItem: FontStyle!
  var extraInputMenuTitle: FontStyle!

  init() {
    keyText = FontStyle(delegate: self, size: 22)
    systemKeyText = FontStyle(delegate: self, size: 12)
    nextKeyboardMenu = FontStyle(delegate: self, size: 14)

    keyDownView = FontStyle(delegate: self, size: 44)
    keyDownInputOptionText = FontStyle(delegate: self, size: 24)

    extraInputItem = FontStyle(delegate: self, size: 18)
    extraInputMenuTitle = FontStyle(delegate: self, size: 20)
  }

  func updateWithScreenSize(_ screenSize: CGSize) {
    let shorterSide = min(screenSize.width, screenSize.height)
    var s = shorterSide / 1.731481481481481

    if shorterSide > 767 {
      // iPad
      s /= 1.5
    }

    keyText.size = round(s * 0.102)
    systemKeyText.size = round(s * 0.065)
    nextKeyboardMenu.size = round(s * 0.065)

    keyDownView.size = round(s * 0.205)
    keyDownInputOptionText.size = round(s * 0.111)

    extraInputItem.size = round(s * 0.076)
    extraInputMenuTitle.size = round(s * 0.086)
  }

  // MARK: FontStyleDelegate
  func fontNameForFontStyle(_: FontStyle) -> String? {
    return mainFontName
  }

  func prefersBoldForFontStyle(_: FontStyle) -> Bool {
    return prefersBoldMainFont
  }
}

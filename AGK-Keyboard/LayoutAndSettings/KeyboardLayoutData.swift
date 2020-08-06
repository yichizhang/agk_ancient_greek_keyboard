//
//  Created by Yichi Zhang on 2017-10-28.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation

class KeyboardLayoutData {

  private static let layoutStyleToFileNameMap = [
    KeyboardLayoutStyle.DefaultA: "layout.el.gr.agk.default.A",
    KeyboardLayoutStyle.DefaultB: "layout.el.gr.agk.default.B",
  ]

  private(set) var layout: KeyboardLayout!

  init(layoutStyle: String) {

    setUp(layoutStyle: layoutStyle)
  }

  private func loadLayout(filename: String) -> KeyboardLayout {

    let bundle = Bundle(for: KeyboardLayoutData.self)

    if let url = bundle.url(forResource: filename, withExtension: "json", subdirectory: "LayoutFiles"),
      let data = try? Data(contentsOf: url),
      let string = String(data: data, encoding: .utf8) {

      return KeyboardLayout.deserialize(from: string) ?? KeyboardLayout()
    }

    return KeyboardLayout()
  }
}

extension KeyboardLayoutData: KeyboardLayoutDataProvider {

  func setUp(layoutStyle: String) {

    let filename = KeyboardLayoutData.layoutStyleToFileNameMap[layoutStyle] ??
      KeyboardLayoutData.layoutStyleToFileNameMap[KeyboardLayoutStyle.DefaultA]!

    layout = loadLayout(filename: filename)

    layout.parentLayouts.forEach {
      (filename: String) in

      let parentLayout = loadLayout(filename: filename)
      self.layout.merge(otherLayout: parentLayout)
    }
  }
  
  func hasDisplayString(letterID: String) -> Bool {
    
    return (layout.displayStringMap[letterID] != nil)
  }

  func displayString(forLetterID letterID: String) -> String {

    return layout.displayStringMap[letterID] ?? letterID
  }

  func inputOptions(forLetterID letterID: String) -> [String]? {

    return layout.inputOptionsMap[letterID]
  }

  func inputString(forLetterID letterID: String) -> String {

    let realInput = layout.inputStringMap[letterID]

    return realInput ?? displayString(forLetterID: letterID)
  }

  func layoutRows(forStateID stateID: String) -> [[AnyObject]]? {

    return layout.layoutStates[stateID]
  }

  func isValidCombination(character: unichar) -> Bool {

    return NSObject.__isCharacterAcceptableCombination(character)
  }
}

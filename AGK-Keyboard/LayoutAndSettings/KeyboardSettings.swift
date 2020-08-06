//
//  Created by Yichi Zhang on 23/08/2016.
//  Copyright (c) 2016 Yichi. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardSettings {
  var mainFontFamily: String? { get }
  var mainFontWeight: String? { get }
  var keyboardLayoutStyle: String { get set }
  var showLowercaseKeys: Bool { get }
  var showWordSuggestionsView: Bool { get }
}

extension KeyboardSettings {
  var mainFontName: String? {
    // TODO: mainFontName and prefersBoldMainFont can be merged to 'mainFont'
    if let mainFontFamily = mainFontFamily {
      let font = UIFont.yz_create(
        family: mainFontFamily,
        weight: mainFontWeight ?? KeyboardFontWeight.Regular,
        size: 20)
      return font?.fontName
    }
    return nil
  }

  var prefersBoldMainFont: Bool {
    return mainFontWeight == KeyboardFontWeight.Bold
  }
}

class UserDefaultsSyncedKeyboardSettings: KeyboardSettings {
  fileprivate var appSettings: AppSettings!

  var mainFontFamily: String? {
    didSet {
      appSettings.mainFontFamily = mainFontFamily
    }
  }

  var mainFontWeight: String? {
    didSet {
      appSettings.mainFontWeight = mainFontWeight
    }
  }

  var keyboardLayoutStyle: String {
    didSet {
      appSettings.keyboardLayoutStyle = keyboardLayoutStyle
    }
  }

  fileprivate(set) var showLowercaseKeys: Bool
  fileprivate(set) var showWordSuggestionsView: Bool

  init() {
    self.appSettings = AppSettings.shared

    self.mainFontFamily = appSettings.mainFontFamily
    self.mainFontWeight = appSettings.mainFontWeight
    self.keyboardLayoutStyle = appSettings.keyboardLayoutStyle
    self.showLowercaseKeys = appSettings.showLowercaseKeys
    self.showWordSuggestionsView = appSettings.showWordSuggestionsView
  }
}

class MockKeyboardSettings: KeyboardSettings {
  var mainFontFamily: String?
  var mainFontWeight: String?
  var keyboardLayoutStyle: String
  var showLowercaseKeys: Bool
  var showWordSuggestionsView: Bool

  init() {
    let appSettings = AppSettings.shared

    self.mainFontFamily = appSettings.mainFontFamily
    self.mainFontWeight = appSettings.mainFontWeight
    self.keyboardLayoutStyle = appSettings.keyboardLayoutStyle
    self.showLowercaseKeys = appSettings.showLowercaseKeys
    self.showWordSuggestionsView = appSettings.showWordSuggestionsView
  }
}

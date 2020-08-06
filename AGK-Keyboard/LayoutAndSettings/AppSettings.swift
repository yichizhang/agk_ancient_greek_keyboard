//
//  Created by Yichi Zhang on 2017-10-28.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

private struct SuiteName {

  static let AGKGroup = "group.yichizhang.AGK-Group"
}

struct KeyboardLayoutStyle {

  static let DefaultA = "Style A"
  static let DefaultB = "Style B"

  static var allValues: [String] {
    return [
      KeyboardLayoutStyle.DefaultA,
      KeyboardLayoutStyle.DefaultB,
    ]
  }
}

struct KeyboardFontWeight {

  static let Regular = "Regular"
  static let Bold = "Bold"
}

extension DefaultsKeys {

  static let mainFontFamily = DefaultsKey<String?>("AGKMainFontFamilyKey")
  static let mainFontWeight = DefaultsKey<String?>("AGKMainFontWeightKey")
  static let keyboardLayoutStyle = DefaultsKey<String?>("AGKKeyboardLayoutNameKey")

  static let showWordSuggestionsView = DefaultsKey<Bool?>("AGKShowWordSuggestionsViewKey")
  static let showLowercaseKeys = DefaultsKey<Bool?>("AGKShowLowercaseKeysKey")

  static let lastMigrationVersion = DefaultsKey<String?>("AGKLastMigrationVersionKey")
}

class AppSettings {

  static let shared = AppSettings()

  private var defaults: UserDefaults

  init() {
    defaults = UserDefaults(suiteName: SuiteName.AGKGroup)!
  }

  private var defaultStringValues: [String: String] = [
    DefaultsKey<String?>.keyboardLayoutStyle._key: KeyboardLayoutStyle.DefaultA,
  ]

  private var defaultBoolValues: [String: Bool] = [
    DefaultsKey<Bool?>.showWordSuggestionsView._key: false,
    DefaultsKey<Bool?>.showLowercaseKeys._key: true,
  ]

  func string(forKey key: DefaultsKey<String?>) -> String? {
    return defaults[key]
  }

  func stringValue(forKey key: DefaultsKey<String?>) -> String {
    return string(forKey: key) ?? defaultStringValues[key._key] ?? ""
  }

  func set(string: String, forKey key: DefaultsKey<String?>) {
    return defaults[key] = string
  }
  
  func boolValue(forKey key: DefaultsKey<Bool?>) -> Bool {
    return defaults[key] ?? defaultBoolValues[key._key] ?? false
  }
  
  func set(bool: Bool, forKey key: DefaultsKey<Bool?>) {
    return defaults[key] = bool
  }
}

extension AppSettings {

  var mainFontFamily: String? {
    get { return string(forKey: .mainFontFamily) }
    set { defaults[.mainFontFamily] = newValue }
  }

  var mainFontWeight: String? {
    get { return string(forKey: .mainFontWeight) }
    set { defaults[.mainFontWeight] = newValue }
  }

  var keyboardLayoutStyle: String {
    get { return stringValue(forKey: .keyboardLayoutStyle) }
    set { defaults[.keyboardLayoutStyle] = newValue }
  }

  var showWordSuggestionsView: Bool {
    get {
      if D.supportsWordSuggestionView {
        return boolValue(forKey: .showWordSuggestionsView)
      } else {
        return false
      }
    }
    set {
      if D.supportsWordSuggestionView {
        defaults[.showWordSuggestionsView] = newValue
      }
    }
  }

  var showLowercaseKeys: Bool {
    get { return boolValue(forKey: .showLowercaseKeys) }
    set { defaults[.showLowercaseKeys] = newValue }
  }
}

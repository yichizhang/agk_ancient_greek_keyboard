//
//  Created by Yichi Zhang on 2017-10-28.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import HandyJSON

fileprivate extension Dictionary {

  mutating func unionInPlace(dictionary: Dictionary<Key, Value>) {

    for (key, value) in dictionary {
      self[key] = value
    }
  }
}

class KeyboardLayout: HandyJSON {

  var language: String = ""
  var layoutID: String = ""
  var name: String = ""
  var version: String = ""

  var parentLayouts: [String] = []

  var displayStringMap: [String: String] = [:]
  var inputOptionsMap: [String: [String]] = [:]
  var inputStringMap: [String: String] = [:]
  var layoutStates: [String: [[AnyObject]]] = [:]

  required init() {}

  func merge(otherLayout: KeyboardLayout) {

    displayStringMap.unionInPlace(dictionary: otherLayout.displayStringMap)
    inputOptionsMap.unionInPlace(dictionary: otherLayout.inputOptionsMap)
    inputStringMap.unionInPlace(dictionary: otherLayout.inputStringMap)
    layoutStates.unionInPlace(dictionary: otherLayout.layoutStates)
  }
}

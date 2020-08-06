//
//  Debug.swift
//  AGK
//
//  Created by Yichi on 3/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

let D = Debugger()

class Debugger {

  private(set) var isDebug = false
  let shouldTestCombinedLetter = false
  let supportsWordSuggestionView = true

  private(set) var isRunningUITests: Bool = false

  init() {
    #if DEBUG
      isDebug = true
      isRunningUITests = ProcessInfo.processInfo.arguments.contains("AGKUITests")
    #endif
  }

  // MARK: Logging
  enum LogLevel: Int {
    
    case error = 2
    case warning = 3
    case info = 4
    case verbose = 5
  }
  
  var maxLevel: LogLevel = .info
  
  weak var textView: UITextView?
  var debugText: String = ""
  
  func logInfo(_ string: String) {
    logWithLevel(.info, string: string)
  }

  func logVerbose(_ string: String) {
    logWithLevel(.verbose, string: string)
  }

  fileprivate func logWithLevel(_ level: LogLevel, string: String) {
    #if DEBUG
      if level.rawValue > maxLevel.rawValue {
        return
      }

      debugText = debugText + ", " + string
      if let textView = textView {
        textView.text = debugText
        textView.scrollRangeToVisible(NSRange(location: debugText.utf8.count, length: 0))
      }

      debugPrint(string)
    #endif
  }
}

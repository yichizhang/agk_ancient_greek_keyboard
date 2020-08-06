//
//  AppDetails.swift
//  AGK
//
//  Created by Yichi on 19/05/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

class AppDetails {
  private(set) var appVersion: String = "--"
  private(set) var appName: String = "AGK Ancient Greek Keyboard"
  private(set) var appNameSubTitle: String = "(Polytonic Greek)"
  
  func aboutString(separator: String, includesVersion: Bool) -> String {
    
    var elements: [String] = [appName, appNameSubTitle]
    
    if includesVersion {
      elements.append(
        String(format: "v%@", appVersion)
      )
    }
    
    return elements.joined(separator: separator)
  }

  init() {
    if let s = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      appVersion = s
    }
  }

  static let shared: AppDetails = AppDetails()
}

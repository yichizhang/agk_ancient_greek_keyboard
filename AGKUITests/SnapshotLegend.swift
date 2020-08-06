//
//  Created by Yichi Zhang on 2017-11-05.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import UIKit
import XCTest

func snapshot(_ name: String, shouldSleep: Bool = true) {
  
  let app = XCUIApplication()
  
  if shouldSleep {
    sleep(1)
  }
  
  let screenshot = app.windows.firstMatch.screenshot()
  
  let size = screenshot.image.size
  let w = Int(size.width)
  let h = Int(size.height)
  let s = Int(screenshot.image.scale)
  
  let d = "\(w)x\(h)@\(s)x"
  let url = URL(fileURLWithPath: "/Users/yichi/aaa/\(d)-\(name).png")
  
  try? screenshot.pngRepresentation.write(to: url)
}

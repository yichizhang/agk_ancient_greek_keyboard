//
//  Created by YICHI ZHANG on 15/04/2016.
//  Copyright (c) 2016 Yichi. All rights reserved.
//

import Foundation
import UIKit
import XCTest

extension XCTestCase {
  
  func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 15,  file: String = #file, line: Int = #line) {
    let existsPredicate = NSPredicate(format: "exists == true")
    
    expectation(for: existsPredicate,
                evaluatedWith: element, handler: nil)
    
    waitForExpectations(timeout: timeout) { (error) -> Void in
      if (error != nil) {
        let message = "Failed to find \(element) after \(timeout) seconds."
        self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
      }
    }
  }
}

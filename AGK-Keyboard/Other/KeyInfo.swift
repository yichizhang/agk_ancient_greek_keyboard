//
//  Created by Yichi on 8/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

class SystemKeyInfo {
  var keyFunction: SystemKeyFunction!
  var rect: CGRect!

  init(keyFunction: SystemKeyFunction,
       rect: CGRect = CGRect.zero) {
    self.keyFunction = keyFunction
    self.rect = rect
  }
}

class KeyInfo {
  var letter: String!
  var rect: CGRect!
  var row: Int! // Top row = 0

  init(letter: String = "",
       rect: CGRect = CGRect.zero,
       row: Int = -1) {
    self.letter = letter
    self.rect = rect
    self.row = row
  }
}

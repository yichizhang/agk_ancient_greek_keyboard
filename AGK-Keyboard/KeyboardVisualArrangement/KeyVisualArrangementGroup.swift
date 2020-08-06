//
//  Created by Yichi Zhang on 6/07/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

enum KeyVisualArrangementGroupAlignment {
  case leading
  case center
  case trailing
}

class KeyVisualArrangementGroup {
  var keyArrangements = [KeyVisualArrangement]()
  var alignment: KeyVisualArrangementGroupAlignment = .center

  var width: CGFloat = 0

  func append(_ key: KeyVisualArrangement) {
    keyArrangements.append(key)
  }
}

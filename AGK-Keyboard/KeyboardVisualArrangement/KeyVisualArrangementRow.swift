//
//  Created by Yichi Zhang on 6/07/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class KeyVisualArrangementRow {
  var groups = [KeyVisualArrangementGroup]()

  var keyArrangements: [KeyVisualArrangement] {
    return groups.flatMap({ (group: KeyVisualArrangementGroup) -> [KeyVisualArrangement] in
      group.keyArrangements
    })
  }

  func appendNewGroup() {
    let group = KeyVisualArrangementGroup()
    groups.append(group)
  }

  func appendToLastGroup(_ key: KeyVisualArrangement) {
    if groups.count == 0 {
      appendNewGroup()
    }
    groups.last!.append(key)
  }
}

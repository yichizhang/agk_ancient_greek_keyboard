//
//  Created by Yichi Zhang on 17/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation
import UIKit

extension UIEdgeInsets {
  init(uniform: CGFloat) {
    top = uniform
    left = uniform
    bottom = uniform
    right = uniform
  }

  init(horizontal: CGFloat, vertical: CGFloat) {
    top = vertical
    left = horizontal
    bottom = vertical
    right = horizontal
  }
}

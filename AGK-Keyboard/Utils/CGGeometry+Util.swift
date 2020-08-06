//
//  Created by Yichi Zhang on 19/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

extension CGRect {

  mutating func makeIntegralInPlace() {
    origin.x = floor(origin.x)
    origin.y = floor(origin.y)
    size.width = ceil(size.width)
    size.height = ceil(size.height)
  }

  mutating func insetInPlace(dx: CGFloat, dy: CGFloat) {
    origin.x -= dx
    origin.y -= dy
    size.width -= 2.0 * dx
    size.height -= 2.0 * dy
  }
}

extension CGSize {

  func insetBy(_ insets: UIEdgeInsets) -> CGSize {
    return CGSize(
      width: width - (insets.left + insets.right),
      height: height - (insets.top + insets.bottom)
    )
  }
  
  var desc: String {
    return "\(Int(width))x\(Int(height))"
  }
}

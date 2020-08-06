//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

extension UIImage {
  class func createImageOfSize(
    _ size: CGSize,
    usingBlock block: ((_ context: CGContext) -> Void)) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

    defer {
      UIGraphicsEndImageContext()
    }

    if let context = UIGraphicsGetCurrentContext() {
      block(context)
    }

    return UIGraphicsGetImageFromCurrentImageContext()
  }
}

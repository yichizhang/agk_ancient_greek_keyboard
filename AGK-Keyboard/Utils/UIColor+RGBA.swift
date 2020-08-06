//
//  Created by Yichi Zhang on 11/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

extension UIColor {
  var hexString: String {
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0

    getRed(&r, green: &g, blue: &b, alpha: &a)

    return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
  }
}

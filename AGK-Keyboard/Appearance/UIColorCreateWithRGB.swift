//
//  Created by Yichi Zhang on 20/06/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation
import UIKit

func UIColorCreateWithRGB(_ r: CGFloat, _ g: CGFloat? = nil, _ b: CGFloat? = nil) -> UIColor
{
  let _255: CGFloat = 255
  return UIColor(red: r / _255,
                 green: (g ?? r) / _255,
                 blue: (b ?? r) / _255,
                 alpha: 1)
}

func UIColorCreateWithRGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor
{
  let _255: CGFloat = 255
  return UIColor(red: r / _255, green: g / _255, blue: b / _255, alpha: a / _255)
}

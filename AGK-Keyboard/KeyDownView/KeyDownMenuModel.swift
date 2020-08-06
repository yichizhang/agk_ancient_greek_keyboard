//
//  Created by Yichi Zhang on 18/07/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

struct KeyDownMenuOption
{
  let ID: String
  let displayString: String?
}

struct KeyDownMenuModel
{
  let options: [KeyDownMenuOption]
  let defaultOptionID: String?
}

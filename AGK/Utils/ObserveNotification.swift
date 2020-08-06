//
//  Created by Yichi Zhang on 2017-10-29.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import UIKit

func ObserveNotification(
  _ name: NSNotification.Name,
  object: Any? = nil,
  queue: OperationQueue? = OperationQueue.main,
  using closure: @escaping (Notification) -> Void) {

  NotificationCenter.default.addObserver(
    forName: name,
    object: object,
    queue: queue,
    using: closure
  )
}

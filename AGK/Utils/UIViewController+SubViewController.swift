//
//  Created by Yichi Zhang on 25/08/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import UIKit

extension UIViewController {
  func yz_addChildViewController(_ childController: UIViewController) {
    childController.willMove(toParent: self)

    view.addSubview(childController.view)

    childController.didMove(toParent: self)
  }

  func yz_removeChildViewController(_ childController: UIViewController) {
    childController.willMove(toParent: nil)

    childController.view.removeFromSuperview()

    childController.didMove(toParent: nil)
  }
}

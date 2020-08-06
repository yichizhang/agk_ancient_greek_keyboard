//
//  Created by Yichi Zhang on 2017-11-03.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import UIKit
import Async

protocol CanUpdateKeyboardPreview: class {
  
  func updateKeyboardPreview()
}

class KeyboardPreviewController: UIViewController, CanUpdateKeyboardPreview {
  
  fileprivate lazy var keyboardVC: MockKeyboardViewController = {
    MockKeyboardViewController()
  }()
  
  var selectionVC: UIViewController!
  func createSelectionViewController() -> UIViewController {
    fatalError("override this method")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    
    edgesForExtendedLayout = UIRectEdge()
    
    yz_addChildViewController(keyboardVC)
    keyboardVC.view.ql_edges([.top, .left, .right])
    
    self.selectionVC = createSelectionViewController()
    yz_addChildViewController(selectionVC)
    selectionVC.view.ql_attribute(.top, toView: keyboardVC.view, on: .bottom)
    selectionVC.view.ql_edges([.left, .bottom, .right])
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate(
      alongsideTransition: { (_: UIViewControllerTransitionCoordinatorContext!) -> Void in
        
        self.keyboardVC.update(containerSize: size)
    }, completion: { (_: UIViewControllerTransitionCoordinatorContext!) -> Void in
      Async.main(after: 0.01) {
        
        self.keyboardVC.update()
      }
    })
    
    super.viewWillTransition(to: size, with: coordinator)
  }
  
  // MARK: - CanUpdateKeyboardPreview
  func updateKeyboardPreview() {
    keyboardVC.update()
  }
}

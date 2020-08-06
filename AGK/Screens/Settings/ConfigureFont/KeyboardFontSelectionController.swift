//
//  Created by Yichi Zhang on 25/08/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation
import UIKit
import Async

class KeyboardFontSelectionController: KeyboardPreviewController {
  
  override func createSelectionViewController() -> UIViewController {
    return FontSelectionForm(style: .grouped).then { $0.delegate = self }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Font"
  }
}

extension KeyboardFontSelectionController: FontSelectionFormDelegate {
  
  func formDidUpdate() {
    
    updateKeyboardPreview()
  }
}

//
//  Created by YICHI ZHANG on 7/05/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class KeyboardInputViewModel {
  var typer: TextTyper!
  weak var viewController: KeyboardInputViewController?

  fileprivate(set) lazy var keyboardSettings: KeyboardSettings = {
    UserDefaultsSyncedKeyboardSettings()
  }()

  init(viewController: KeyboardInputViewController) {
    self.viewController = viewController
    typer = TextTyper(delegate: self)
  }
}

extension KeyboardInputViewModel: TextTyperProtocol {
  func textTyper(_: TextTyper, insertText text: String) {
    viewController?.textDocumentProxy.insertText(text)
  }

  func textTyperDeleteBackward(_: TextTyper) {
    viewController?.textDocumentProxy.deleteBackward()
  }

  func textTyperNextKeyboard(_: TextTyper) {
    viewController?.advanceToNextInputMode()
  }
}

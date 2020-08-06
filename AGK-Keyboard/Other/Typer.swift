//
//  Typer.swift
//  AGK
//
//  Created by Yichi on 6/09/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit

protocol TextTyperProtocol: class {
  func textTyper(_ typer: TextTyper, insertText text: String)

  func textTyperDeleteBackward(_ typer: TextTyper)

  func textTyperNextKeyboard(_ typer: TextTyper)
}

class TextTyper {
  weak var delegate: TextTyperProtocol?

  init(delegate: TextTyperProtocol) {
    self.delegate = delegate
  }

  func insertText(_ text: String) {
    delegate?.textTyper(self, insertText: text)
  }

  func deleteBackward() {
    delegate?.textTyperDeleteBackward(self)
  }

  func nextKeyboard() {
    delegate?.textTyperNextKeyboard(self)
  }
}

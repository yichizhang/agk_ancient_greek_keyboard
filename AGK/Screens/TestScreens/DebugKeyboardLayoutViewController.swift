//
//  Created by YICHI ZHANG on 12/04/2016.
//  Copyright (c) 2016 Yichi. All rights reserved.
//

import Foundation
import UIKit
import Actions

class DebugKeyboardLayoutViewController: UIViewController {
  private var textView: UITextView!
  private var currentTextView: UITextView? {
    return textView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Keyboard Layout"
    
    view.backgroundColor = UIColor.white
    
    textView = UITextView(frame: view.bounds).then {
      $0.isEditable = false // So that system keyboard does not show and block our debug keyboard
      $0.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 30)
      self.view.addSubview($0)
      $0.ql_edges()
    }
    
    setUpKeyboard()
    
    setUpToolbar()
  }
  
  // MARK: Keyboard
  private var keyboardView: KeyboardView!
  private var typer: TextTyper?
  private var sizeConstraints: SizeConstraints?
  
  var totalKeyboardSize: CGSize {
    return KeyboardConstantsFactory.recommendedTotalKeyboardSize(
      forContainerSize: view.frame.size,
      hasWordSuggestionsRow: AppSettings.shared.showWordSuggestionsView
    )
  }
  
  private lazy var keyboardSettings: KeyboardSettings = {
    UserDefaultsSyncedKeyboardSettings()
  }()
  
  private func setUpKeyboard() {
    
    typer = TextTyper(delegate: self)
    
    keyboardView = KeyboardView(
      frame: CGRect(origin: .zero, size: totalKeyboardSize),
      typer: typer,
      settings: keyboardSettings,
      textInputAppearance: textView.keyboardAppearance
      ).then {
        
        self.view.addSubview($0)
        $0.ql_attribute(.centerX)
        $0.ql_attribute(.centerY)
        self.sizeConstraints = $0.ql_set(size: totalKeyboardSize)
    }
  }
  
  private func changeKeyboardWidth(delta: CGFloat) {
    sizeConstraints?.width?.constant += delta
  }
  
  private func changeKeyboardHeight(delta: CGFloat) {
    sizeConstraints?.height?.constant += delta
  }
  
  private func resetKeyboardSize() {
    sizeConstraints?.width?.constant = totalKeyboardSize.width
    sizeConstraints?.height?.constant = totalKeyboardSize.height
  }
  
  // MARK: Toolbar
  private func setUpToolbar() {
    
    let delta = CGFloat(10)
    
    view.addSubview(UIToolbar().then {
      $0.items = [
        UIBarButtonItem(title: "w+") { [weak self] in
          self?.changeKeyboardWidth(delta: delta)
        },
        UIBarButtonItem(title: "w-") { [weak self] in
          self?.changeKeyboardWidth(delta: -delta)
        },
        UIBarButtonItem(title: "h+") { [weak self] in
          self?.changeKeyboardHeight(delta: delta)
        },
        UIBarButtonItem(title: "h-") { [weak self] in
          self?.changeKeyboardHeight(delta: -delta)
        },
        UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: "reset") { [weak self] in
          self?.resetKeyboardSize()
        },
      ]
      
      self.view.addSubview($0)
      $0.ql_edges([.left, .bottom, .right])
    })
  }
}

extension DebugKeyboardLayoutViewController: TextTyperProtocol {
  func textTyper(_: TextTyper, insertText text: String) {
    currentTextView?.insertText(text)
  }
  
  func textTyperDeleteBackward(_: TextTyper) {
    currentTextView?.deleteBackward()
  }
  
  func textTyperNextKeyboard(_: TextTyper) {
  }
}

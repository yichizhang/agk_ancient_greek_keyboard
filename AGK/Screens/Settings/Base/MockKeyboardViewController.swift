//
//  Created by Yichi Zhang on 25/08/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class MockKeyboardViewController: UIViewController {

  private var keyboardView: KeyboardView!
  private var keyboardSettings: MockKeyboardSettings! {
    let ret = MockKeyboardSettings()
    ret.showWordSuggestionsView = false
    return ret
  }

  func update(containerSize: CGSize? = nil) {
    setUpKeyboardView(containerSize: containerSize)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpKeyboardView()
  }

  private func setUpKeyboardView(containerSize: CGSize? = nil) {
    keyboardView?.removeFromSuperview()

    let totalKeyboardSize = KeyboardConstantsFactory.recommendedTotalKeyboardSize(
      forContainerSize: containerSize ?? UIScreen.main.bounds.size,
      hasWordSuggestionsRow: false
    )

    keyboardView = KeyboardView(
      frame: CGRect(origin: .zero, size: totalKeyboardSize),
      typer: nil,
      settings: keyboardSettings,
      textInputAppearance: .dark)

    view.addSubview(keyboardView)
    keyboardView.ql_edges()
    keyboardView.ql_set(.height, constant: totalKeyboardSize.height)

    keyboardView.isUserInteractionEnabled = false
  }
}

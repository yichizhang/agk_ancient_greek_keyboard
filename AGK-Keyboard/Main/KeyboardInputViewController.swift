//
//  Created by Yichi on 23/05/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit

class KeyboardInputViewController: UIInputViewController, KeyboardDelegate {

  private(set) lazy var viewModel: KeyboardInputViewModel = { [unowned self] in
    KeyboardInputViewModel(viewController: self)
  }()
  
  override func didReceiveMemoryWarning() {
    self.keyboardView?.didReceiveMemoryWarning()
    
    super.didReceiveMemoryWarning()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    makeKeyboardGreatAgain()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    makeKeyboardGreatAgain()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    makeKeyboardGreatAgain()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    makeKeyboardGreatAgain()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

    makeKeyboardGreatAgain()

    super.viewWillTransition(to: size, with: coordinator)
  }

  // MARK: - Keyboard
  private func makeKeyboardGreatAgain() {

    setUpKeyboardViewIfNeeded()
    configureKeyboardViewConstraints()
  }

  // MARK: Set up
  private var keyboardView: KeyboardView!

  private func setUpKeyboardViewIfNeeded() {

    if keyboardView != nil {
      return
    }

    if let view = inputView {

      keyboardView = KeyboardView(
        frame: CGRect.zero,
        typer: viewModel.typer,
        delegate: self,
        settings: viewModel.keyboardSettings,
        textInputAppearance: textDocumentProxy.keyboardAppearance
      )
      keyboardView.translatesAutoresizingMaskIntoConstraints = false

      view.backgroundColor = keyboardView.backgroundColor
      view.layer.backgroundColor = keyboardView.backgroundColor?.cgColor
      view.addSubview(keyboardView)
    }
  }

  // MARK: Constraints
  private var edgeConstraints: EdgeConstraints?
  private var bottomConstraint: NSLayoutConstraint?

  private var shouldConfigureConstraints: Bool {
    return edgeConstraints == nil
  }
  
  private var hasCustomHeight: Bool {
    let iPhoneX = !needsInputModeSwitchKey
    let hasWordSuggestionsView = AppSettings.shared.showWordSuggestionsView
    let iPad = (UIDevice.current.userInterfaceIdiom == .pad)
    
    return iPhoneX || hasWordSuggestionsView || iPad
  }

  private func configureKeyboardViewConstraints() {

    if shouldConfigureConstraints {

      edgeConstraints = keyboardView.ql_edges()
      bottomConstraint = keyboardView.heightAnchor.constraint(equalToConstant: 188)
    }

    if let bottomConstraint = bottomConstraint {

      if hasCustomHeight {
        
        var size = UIScreen.main.bounds.size
        size.width -= (view.safeAreaInsets.left + view.safeAreaInsets.right)
        size.height -= (view.safeAreaInsets.top + view.safeAreaInsets.bottom)

        let c = KeyboardConstantsFactory.recommendedTotalKeyboardSize(forContainerSize: size, hasWordSuggestionsRow: AppSettings.shared.showWordSuggestionsView)
        
        bottomConstraint.constant = c.height
        bottomConstraint.priority = .required

        bottomConstraint.isActive = true
      } else {
        bottomConstraint.isActive = false
      }
    }
  }
}

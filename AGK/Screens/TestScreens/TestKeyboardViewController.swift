//
//  TestKeyboardViewController.swift
//  AGK
//
//  Created by Yichi on 19/05/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit
import Foundation

class TestKeyboardViewController: UIViewController {
  var textView: UITextView!
  var kbView: KeyboardView!

  var typer: TextTyper!
  weak var currentTextView: UITextView?

  fileprivate lazy var keyboardSettings: KeyboardSettings = {
    if D.isRunningUITests {
      let settings = MockKeyboardSettings()
      settings.showWordSuggestionsView = false
      settings.keyboardLayoutStyle = KeyboardLayoutStyle.DefaultB
      return settings
    }

    return UserDefaultsSyncedKeyboardSettings()
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    view.backgroundColor = UIColor.white

    title = "Keyboard"

    textView = UITextView(frame: CGRect.zero)
    textView.accessibilityIdentifier = "TextView"
    textView.keyboardAppearance = .dark
    
    textView.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 30)
    view.addSubview(textView)
    textView.ql_edges(insetH: 20.0, insetV: 0.0)

    if D.isRunningUITests {
      textView.text = "ἄνδρα μοι ἔννεπε, μοῦσα, πολύτροπον, ὃς μάλα πολλὰ πλάγχθη, ἐπεὶ Τροίης ἱερὸν πτολίεθρον ἔπερσεν: πολλῶν δ' ἀνθρώπων ἴδεν ἄστεα καὶ νόον ἔγνω, πολλὰ δ' ὅ γ' ἐν πόντῳ πάθεν ἄλγεα ὃν κατὰ θυμόν, ἀρνύμενος ἥν τε ψυχὴν καὶ νόστον ἑταίρων. ἀλλ' οὐδ' ὣς ἑτάρους ἐρρύσατο, ἱέμενός περ: αὐτῶν γὰρ σφετέρῃσιν ἀτασθαλίῃσιν ὄλοντο, νήπιοι, οἳ κατὰ βοῦς Ὑπερίονος Ἠελίοιο ἤσθιον: αὐτὰρ ὁ τοῖσιν ἀφείλετο νόστιμον ἦμαρ. τῶν ἁμόθεν γε, θεά, θύγατερ Διός, εἰπὲ καὶ ἡμῖν."
    }

    typer = TextTyper(delegate: self)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    loadKeyboard()
  }

  override func viewWillTransition(to _: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    coordinator.animate(
      alongsideTransition: { (_: UIViewControllerTransitionCoordinatorContext!) -> Void in

        self.textView.resignFirstResponder()
      }, completion: { (_: UIViewControllerTransitionCoordinatorContext!) -> Void in

        self.loadKeyboard()
    })
  }

  func loadKeyboard() {

    let containerSize = UIScreen.main.bounds.size.insetBy(view.safeAreaInsets)

    let totalKeyboardSize = KeyboardConstantsFactory.recommendedTotalKeyboardSize(
      forContainerSize: containerSize,
      hasWordSuggestionsRow: AppSettings.shared.showWordSuggestionsView
    )

    let c = KeyboardConstantsFactory.create(
      totalKeyboardSize: totalKeyboardSize,
      hasWordSuggestionsRow: keyboardSettings.showWordSuggestionsView
    )

    let kbFrame = CGRect(
      x: 0,
      y: 0,
      width: containerSize.width,
      height: c.keyboardTotalHeight
    )

    kbView = KeyboardView(
      frame: kbFrame,
      typer: typer,
      settings: keyboardSettings,
      textInputAppearance: textView.keyboardAppearance
    )

    let kbWrapper = UIView(frame: kbFrame).then {
      $0.addSubview(kbView)

      var inset = self.view.safeAreaInsets
      inset.top = 0

      $0.frame.size.height += inset.bottom
      $0.backgroundColor = kbView.backgroundColor

      kbView.ql_edges(inset: inset)
    }

    kbView.usingAsInputView = true
    kbWrapper.autoresizingMask = UIView.AutoresizingMask()

    textView.inputView = kbWrapper
    currentTextView = textView

    textView.becomeFirstResponder()
  }
}

extension TestKeyboardViewController: TextTyperProtocol {

  func textTyper(_: TextTyper, insertText text: String) {
    currentTextView?.insertText(text)
  }

  func textTyperDeleteBackward(_: TextTyper) {
    currentTextView?.deleteBackward()
  }

  func textTyperNextKeyboard(_: TextTyper) {
  }
}

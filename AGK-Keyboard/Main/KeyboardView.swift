//
//  KeyboardView.swift
//  AGK
//
//  Created by Yichi on 2/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

class KeyboardView: UIView {
  fileprivate var viewModel: KeyboardViewModel!

  weak var delegate: KeyboardDelegate?
  
  var isPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)
  var usingAsInputView = false
  
  private var _constants: KeyboardConstants?

  var constants: KeyboardConstants {
    if _constants == nil {
      _constants = KeyboardConstantsFactory.create(
        totalKeyboardSize: totalKeyboardSize,
        hasWordSuggestionsRow: viewModel.settings.showWordSuggestionsView
      )
    }
    return _constants!
  }

  var totalKeyboardSize: CGSize {
    return self.frame.size
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(
      width: super.intrinsicContentSize.width,
      height: constants.keyboardTotalHeight
    )
  }

  fileprivate var frameWidthOfLastLayout = 0
  fileprivate var frameHeightOfLastLayout = 0
  
  fileprivate var visualArrangement: KeyboardVisualArrangement?
  
  private var _styleManager: KeyboardStyleManager!
  var styleManager: KeyboardStyleManager {
    if _styleManager == nil {
      _styleManager = KeyboardStyleManager(
        appearance: textInputAppearance ?? .light,
        mainFontName: viewModel.settings.mainFontName,
        prefersBoldMainFont: viewModel.settings.prefersBoldMainFont
      )
    }
    return _styleManager
  }

  var textInputAppearance: UIKeyboardAppearance? {
    didSet {
      self._styleManager = nil
      viewModel.forceUpdateKeyboard()
      updateBackgroundColor()
    }
  }
  
  fileprivate var wordSuggestionsView: WordSuggestionsView?

  fileprivate var keyboardWidth: CGFloat = 0

  fileprivate var keyButtonsForReuse: [String: KeyButton] = [:]
  fileprivate var keyButtonContainer = KeyButtonContainer()
  fileprivate var keyImageProvider = KeyImageProvider()
  fileprivate var systemKeyDisplayMap: [String: Any]!
  fileprivate var systemKeyStyleMapping: [String: Any]!

  fileprivate var keyboardKeysView: UIView!
  
  func didReceiveMemoryWarning() {
    keyButtonsForReuse.removeAll()
  }

  required
  init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(
    frame: CGRect,
    typer: TextTyper?,
    delegate: KeyboardDelegate? = nil,
    settings: KeyboardSettings,
    textInputAppearance: UIKeyboardAppearance? = nil) {
    super.init(frame: frame)

    viewModel = KeyboardViewModel(
      view: self,
      typer: typer,
      settings: settings
    )

    self.delegate = delegate
    
    self.textInputAppearance = textInputAppearance

    if viewModel.settings.showWordSuggestionsView {
      wordSuggestionsView = WordSuggestionsView(frame: bounds)
      addSubview(wordSuggestionsView!)
    }

    keyboardKeysView = UIView(frame: bounds)
    keyboardKeysView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(keyboardKeysView)
    
    updateBackgroundColor()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
    _constants = nil

    styleManager.updateFontSizesWithScreenSize(UIScreen.main.bounds.size)
    
    var keysViewOrigY: CGFloat = 0.0

    if let wordSuggestionsView = wordSuggestionsView {
      
      wordSuggestionsView.frame = CGRect(
        x: 0.0,
        y: 0.0,
        width: frame.width,
        height: constants.wordSuggestionsRowHeight
      )

      keysViewOrigY = wordSuggestionsView.frame.maxY
    }
    
    keyboardKeysView.frame = CGRect(
      x: 0.0,
      y: keysViewOrigY,
      width: frame.width,
      height: constants.keyboardKeysViewHeight
    )

    if Int(frame.width) != frameWidthOfLastLayout ||
      Int(frame.height) != frameHeightOfLastLayout {
      viewModel.forceUpdateKeyboard()

      frameWidthOfLastLayout = Int(frame.width)
      frameHeightOfLastLayout = Int(frame.height)
    }
  }

  // MARK: Keyboard
  fileprivate func systemKeyStyle(ID: String) -> KeyButtonStyle? {
    if systemKeyStyleMapping == nil {
      systemKeyStyleMapping = createSystemKeyStyleMapping()
    }

    if let mapping = systemKeyStyleMapping[ID] as? [KeyboardState: KeyButtonStyle] {
      return mapping[viewModel.state]
    } else {
      return systemKeyStyleMapping[ID] as? KeyButtonStyle ?? nil
    }
  }

  fileprivate func systemKeySymbolOrText(ID: String) -> Any? {
    if systemKeyDisplayMap == nil {
      systemKeyDisplayMap = createSystemKeyDisplayMap()
    }

    if let mapping = systemKeyDisplayMap[ID] as? [KeyboardState: Any] {
      return mapping[viewModel.state]
    } else {
      return systemKeyDisplayMap[ID]
    }
  }

  func updateWith(keyboardVisualArrangement aVisualArrangement: KeyboardVisualArrangement) {
    // Clean
    for (_, button) in keyButtonContainer {
      enqueueKeyButtonForReuse(button)

      button.removeFromSuperview()
    }
    keyButtonContainer.removeAll()

    // Set
    visualArrangement = aVisualArrangement

    guard let visualArrangement = visualArrangement else {
      return
    }

    // Update
    let style = styleManager.createKeyStyle()
    visualArrangement.keyArrangements.forEach { (key: KeyVisualArrangement) in
      let button = dequeueReusableKeyButton(keyID: key.ID)

      if key.isSystemKey {
        button.style = systemKeyStyle(ID: key.ID) ?? style
      } else {
        button.style = style
      }

      button.frame = key.frame
      button.keyButtonShapeInset = visualArrangement.keyButtonShapeInset
      
      button.isUserInteractionEnabled = false
      button.removeTarget(nil, action: nil, for: UIControl.Event.allEvents)
      
      if isInputModeKey(ID: key.ID) {
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: UIControl.Event.allEvents)
      }
      
      button.ID = key.ID
      button.accessibilityIdentifier = key.ID
      button.imageProvider = self.keyImageProvider

      if key.isSystemKey {
        button.textOrSymbol = systemKeySymbolOrText(ID: key.ID) ?? "x"
      } else {
        button.textOrSymbol = viewModel.displayString(letterKeyID: key.ID)
      }

      keyboardKeysView.addSubview(button)
      keyButtonContainer[key.ID] = button

      button.setNeedsDisplay()
      button.configureButton() // iOS 8.4 defect workaround
    }
  }

  // MARK: -- Reuse key buttons
  func enqueueKeyButtonForReuse(_ button: KeyButton) {
    button.prepareForReuse()
    keyButtonsForReuse[button.ID] = button
  }

  func dequeueReusableKeyButton(keyID: String) -> KeyButton {
    if let button = keyButtonsForReuse[keyID] {
      keyButtonsForReuse[keyID] = nil
      return button
    } else {
      let button = KeyButton()
      return button
    }
  }

  // MARK: User interaction
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    for touch in touches {
      if let ID = keyID(pointInKeysView: touch.location(in: keyboardKeysView)) {
        viewModel.touchBegan(touch, ID: ID)

        D.logInfo("touchBegan: \(Unmanaged.passUnretained(touch).toOpaque()), \(touch.tapCount), \(ID)")
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)

    for touch in touches {
      viewModel.touchMoved(touch)
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    for touch in touches {
      viewModel.touchEnded(touch)
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)

    for touch in touches {
      viewModel.touchCancelled(touch)
    }
  }

  // MARK: Display
  func updateBackgroundColor() {
    backgroundColor = styleManager.keyboardBackgroundColor
    wordSuggestionsView?.backgroundColor = styleManager.wordSuggestionsViewBackgroundColor
  }
  
  func update(isSelected: Bool, forKeyID ID: String?) {
    if let ID = ID,
      let button = keyButtonContainer[ID] {
      button.isSelected = isSelected
    }
  }

  func isOnTopRow(keyID ID: String) -> Bool {
    return keyButtonContainer[ID]?.isTopRow ?? false
  }

  func keyID(pointInKeysView point: CGPoint) -> String? {
    return keyButtonContainer.keyID(point: point)
  }

  func createSystemKeyDisplayMap() -> [String: Any] {
    let shiftSwitchMapping: [KeyboardState: Any] = [
      KeyboardState.Lowercase: SystemKeySymbol.shift,
      KeyboardState.Uppercase: SystemKeySymbol.shift,
      KeyboardState.CapsLocked: SystemKeySymbol.capsLock,
      KeyboardState.Number: "#+=",
      KeyboardState.Punctuation: "123",
    ]

    let bottomRowSwitchMapping: [KeyboardState: Any] = [
      KeyboardState.Lowercase: "123",
      KeyboardState.Uppercase: "123",
      KeyboardState.CapsLocked: "123",
      KeyboardState.Number: "ABC",
      KeyboardState.Punctuation: "ABC",
    ]

    var mapping = [String: Any]()

    mapping[SystemKeyFunction.ShiftSwitch.rawValue] = shiftSwitchMapping
    mapping[SystemKeyFunction.Delete.rawValue] = SystemKeySymbol.delete

    mapping[SystemKeyFunction.Back.rawValue] = "back"
    mapping[SystemKeyFunction.BottomRowSwitch.rawValue] = bottomRowSwitchMapping
    mapping[SystemKeyFunction.NextKeyboard.rawValue] = SystemKeySymbol.globe

    mapping[SystemKeyFunction.Space.rawValue] = " "
    mapping[SystemKeyFunction.ExtraLetters.rawValue] = "more"
    mapping[SystemKeyFunction.Done.rawValue] = SystemKeySymbol.enter

    return mapping
  }

  func createSystemKeyStyleMapping() -> [String: Any] {
    let noChangeStyle = styleManager.systemKeyNoChangeStyle
    let hasChangeStyle = styleManager.systemKeyHasChangeStyle
    let hasChangeReversedStyle = styleManager.systemKeyHasChangeReversedStyle
    let shiftOnStyle = styleManager.systemKeyShiftOnStyle
    let actionButtonStyle = styleManager.systemKeyActionButtonStyle
    let moreSymbolsStyle = styleManager.moreSymbolKeyStyle

    let shiftSwitchMapping: [KeyboardState: KeyButtonStyle] = [
      KeyboardState.Lowercase: noChangeStyle!,
      KeyboardState.Uppercase: shiftOnStyle!,
      KeyboardState.CapsLocked: shiftOnStyle!,
      KeyboardState.Number: noChangeStyle!,
      KeyboardState.Punctuation: noChangeStyle!,
    ]

    var mapping = [String: Any]()

    mapping[SystemKeyFunction.ShiftSwitch.rawValue] = shiftSwitchMapping
    mapping[SystemKeyFunction.Delete.rawValue] = hasChangeStyle

    mapping[SystemKeyFunction.Back.rawValue] = noChangeStyle
    mapping[SystemKeyFunction.BottomRowSwitch.rawValue] = noChangeStyle
    mapping[SystemKeyFunction.NextKeyboard.rawValue] = hasChangeStyle

    mapping[SystemKeyFunction.Space.rawValue] = hasChangeReversedStyle
    mapping[SystemKeyFunction.ExtraLetters.rawValue] = moreSymbolsStyle
    mapping[SystemKeyFunction.Done.rawValue] = actionButtonStyle

    return mapping
  }

  // MARK: -- Set Selected / Key Down Hint View
  func setHintViewVisibleIfNeeded(_ visible: Bool, forKeyID ID: String?) {
    if isPad {
      return
    }

    if let ID = ID,
      let button = keyButtonContainer[ID] {
      if button.isTopRow &&
        viewModel.showTopRowKeyDownHintView == true {
        button.setTopRowKeyDownHintViewVisible(visible)
      } else {
        button.setKeyDownHintViewVisible(visible)
      }
    }
  }

  // MARK: -- Key Down Input Options View
  fileprivate var inputOptionsView: KeyDownMenuView?

  var isInputOptionsVisible: Bool {
    return inputOptionsView?.superview != nil
  }

  var inputOptionSelection: String? {
    return inputOptionsView?.viewModel.selectedOption
  }

  func hideInputOptionsView() {
    inputOptionsView?.removeFromSuperview()
    inputOptionsView = nil
  }

  func showOptionsView(model: KeyDownMenuModel, keyID ID: String) {
    
    hideInputOptionsView()

    guard let button = keyButtonContainer[ID] else {
      return
    }

    let keyFrame = button.keyFrame

    inputOptionsView = KeyDownMenuView(
      keyFrame: button.keyFrame,
      model: model,
      style: KeyDownMenuViewStyle(
        font: styleManager.textStyle.keyText.font,
        cornerRadius: KeyButtonStyle.cornerRadius(keySize: keyFrame.size),
        backgroundColor: styleManager.keyColor,
        shadowColor: styleManager.keyShadowColor,
        textColor: styleManager.keyTextColor,
        selectedTextColor: UIColor.white,
        optionSize: CGSize(
          width: keyFrame.width,
          height: keyFrame.height * 0.9),
        superviewWidth: superview!.bounds.width),
      optionAlignment: model.options.count > 5 ? .grid : .horizontal)

    keyboardKeysView.addSubview(inputOptionsView!)
  }

  func updateInputOptionsViewSelectionWithPoint(_ point: CGPoint) {
    inputOptionsView?.updateSelectionWithPoint(point)
  }

  // MARK: -- Next Keyboard
  func isInputModeKey(ID: String) -> Bool {
    return ID == "SYSTEM KEY - NEXT KEYBOARD"
  }
  
  @objc func handleInputModeList(from view: UIView, with event: UIEvent) {
    
    delegate?.handleInputModeList(from: view, with: event)
  }
  
  fileprivate var nextKeyboardMenuView: KeyDownMenuView?

  /*
  var nextKeyboardMenuSelection: String? {
    return nextKeyboardMenuView?.viewModel.selectedOption
  }
   */

  var isNextKeyboardMenuVisible: Bool {
    return nextKeyboardMenuView?.superview != nil
  }

  /*
  func hideNextKeyboardMenu() {
    nextKeyboardMenuView?.removeFromSuperview()
    nextKeyboardMenuView = nil
  }

  func displayNextKeyboardMenuWithModel(_ model: KeyDownMenuModel) {
    if let _ = nextKeyboardMenuView?.superview {
      nextKeyboardMenuView?.removeFromSuperview()
    }

    guard let button = keyButtonContainer[SystemKeyFunction.NextKeyboard.rawValue] else {
      return
    }

    let keyFrame = button.keyFrame

    nextKeyboardMenuView = KeyDownMenuView(
      keyFrame: keyFrame,
      model: model,
      style: KeyDownMenuViewStyle(
        font: styleManager.textStyle.nextKeyboardMenu.font,
        cornerRadius: KeyButtonStyle.cornerRadius(keySize: keyFrame.size),
        backgroundColor: styleManager.keyColor,
        shadowColor: styleManager.keyShadowColor,
        textColor: styleManager.keyTextColor,
        selectedTextColor: UIColor.white,
        optionSize: CGSize(
          width: keyFrame.width * 2.66,
          height: keyFrame.height * 0.9),
        superviewWidth: superview!.bounds.width),
      optionAlignment: .vertical)

    keyboardKeysView.addSubview(nextKeyboardMenuView!)
  }

  func updateNextKeyboardMenuSelectionWithPoint(_ point: CGPoint) {
    nextKeyboardMenuView?.updateSelectionWithPoint(point)
  }
  */
}

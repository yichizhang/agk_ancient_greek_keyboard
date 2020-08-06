//  Copyright (c) 2016-present Yichi Zhang. All rights reserved.

import Foundation

class KeyboardViewModel: NSObject {
  weak var typer: TextTyper?

  fileprivate weak var view: KeyboardView?

  fileprivate var layoutData: KeyboardLayoutDataProvider!
  fileprivate let keyboardLayoutStyleOptions: [String] = KeyboardLayoutStyle.allValues

  let showTopRowKeyDownHintView: Bool!
  fileprivate(set) var settings: KeyboardSettings!

  // TODO: Pass this to TouchHandler?
  //  private let deleteKeyTimerInterval = NSTimeInterval(0.09)

  fileprivate var lastLetter: String?

  fileprivate var previousState: KeyboardState?
  fileprivate var _state: KeyboardState = KeyboardState.Lowercase
  var state: KeyboardState {
    return _state
  }

  fileprivate var shiftSwitchNextStateMapping: [KeyboardState: KeyboardState] = [
    .Lowercase: .Uppercase,
    .Uppercase: .Lowercase,
    .CapsLocked: .Lowercase,
    .Number: .Punctuation,
    .Punctuation: .Number,
  ]
  fileprivate var systemKeyVisualArrangementOptionsMapping: [String: [KeyVisualArrangementOption]]!

  fileprivate var touchHandlerMap: [UITouch: Set<TouchHandler>] = [:]

  init(
    view: KeyboardView,
    typer: TextTyper?,
    settings: KeyboardSettings) {
    self.typer = typer
    self.view = view

    self.settings = settings

    showTopRowKeyDownHintView = (settings.showWordSuggestionsView == false)

    layoutData = KeyboardLayoutData(layoutStyle: settings.keyboardLayoutStyle)
  }

  // MARK: Display
  func keyboardViewFrameDidChange() {
    forceUpdateKeyboard()
  }

  func displayString(letterKeyID ID: String) -> String {
    if !settings.showLowercaseKeys {
      
      let orginal = "GREEK SMALL LETTER"
      let updated = "GREEK CAPITAL LETTER"
      
      if ID.contains(orginal) {
        
        let capitalLetterID = ID.replacingOccurrences(of: orginal, with: updated)
        
        if layoutData.hasDisplayString(letterID: capitalLetterID) {
          
          return layoutData.displayString(forLetterID: capitalLetterID)
        }
      }
    }
    
    return layoutData.displayString(forLetterID: ID)
  }

  // MARK: User interaction
  func touchBegan(_ touch: UITouch, ID: String) {
    if let keyFunction = SystemKeyFunction(rawValue: ID) {
      touchBegan(touch, forSystemKeyWithFunction: keyFunction)
    } else {
      touchBegan(touch, letterKeyID: ID)
    }
  }

  func touchMoved(_ touch: UITouch) {
    touchHandlerMap[touch]?.forEach { $0.touchMoved() }
  }

  func touchEnded(_ touch: UITouch) {
    touchHandlerMap[touch]?.forEach { $0.touchEnded() }
    
    self.touchHandlerMap.removeValue(forKey: touch)
  }

  func touchCancelled(_ touch: UITouch) {
    touchHandlerMap[touch]?.forEach { $0.touchCancelled() }
    
    self.touchHandlerMap.removeValue(forKey: touch)
  }

  // MARK: -- User interaction - System keys
  fileprivate func touchBegan(_ touch: UITouch, forSystemKeyWithFunction keyFunction: SystemKeyFunction) {
    guard let view = self.view else { return }

    addTouchHandler(TouchHandler(
      delegate: self,
      touch: touch,
      onBegan: { beganViewID in
        // Touch state
        view.update(isSelected: true, forKeyID: beganViewID)
      },
      onEnd: { touchData in
        // Touch state
        view.update(isSelected: false, forKeyID: touchData.beganViewID)
    }))

    switch keyFunction
    {
    case .ShiftSwitch:
      touchBeganForShiftSwitchKey(touch)
    case .Delete:
      touchBeganForDeleteKey(touch)
    case .Back:
      touchBeganForBackKey(touch)
    case .BottomRowSwitch:
      touchBeganForBottomRowSwitchKey(touch)
    case .NextKeyboard:
      return
    case .Space:
      touchBeganForSpaceKey(touch)
    case .ExtraLetters:
      touchBeganForExtraSymbolsKey(touch)
    case .Done:
      touchBeganForDoneKey(touch)
    }
  }

  fileprivate func touchBeganForShiftSwitchKey(_ touch: UITouch) {
    if touch.tapCount == 2 {
      if state == .Lowercase || state == .Uppercase {
        updateKeyboardState(.CapsLocked)
      }
    } else if let nextState = shiftSwitchNextStateMapping[self.state] {
      updateKeyboardState(nextState)
    }
  }

  fileprivate func touchBeganForDeleteKey(_ touch: UITouch) {
    deleteBackwards()

    addTouchHandler(TouchHandler(
      delegate: self,
      touch: touch,
      onThrottle: ThrottleData(
        triggerInterval: 0.17,
        interval: 0.085) { () -> Void in
          self.deleteBackwards()
    }))
  }

  fileprivate func touchBeganForBackKey(_: UITouch) {
    updateKeyboardState(previousState ?? .Lowercase)
  }

  fileprivate func touchBeganForBottomRowSwitchKey(_: UITouch) {
    if state == .Number || state == .Punctuation {
      updateKeyboardState(.Lowercase)
    } else {
      updateKeyboardState(.Number)
    }
  }
  
  fileprivate func touchBeganForSpaceKey(_: UITouch) {
    enterText(" ")
  }

  fileprivate func touchBeganForExtraSymbolsKey(_: UITouch) {
    updateKeyboardState(.ExtraLetters)
  }

  fileprivate func touchBeganForDoneKey(_: UITouch) {
    enterText("\n")
  }

  // MARK: -- User interaction - Letter key
  fileprivate func touchBegan(_ touch: UITouch, letterKeyID ID: String) {
    guard let view = self.view else { return }

    addTouchHandler(TouchHandler(
      delegate: self,
      touch: touch,
      onBegan: { beganViewID in
        D.logInfo("onBegan")

        // Touch state
        view.update(isSelected: true, forKeyID: beganViewID)

        if self.shouldExpandInputOptionsImmediately(keyID: beganViewID) {
          self.expandInputOptionsIfNeeded(keyID: beganViewID)
        }
      },
      onLongPressDetected: { viewID in
        D.logInfo("onLongPressDetected")

        self.expandInputOptionsIfNeeded(keyID: viewID)
      },
      onMove: { touchData in
        D.logInfo("onMove")

        if view.isInputOptionsVisible {
          view.updateInputOptionsViewSelectionWithPoint(touchData.touchPoint)
        }
      },
      onViewIDChange: { lastViewID, currentViewID in
        D.logInfo("onViewIDChange")

        // Touch state AND hint view
        view.update(isSelected: false, forKeyID: lastViewID)
        view.setHintViewVisibleIfNeeded(false, forKeyID: lastViewID)

        if view.isInputOptionsVisible == false &&
          view.isNextKeyboardMenuVisible == false &&
          self.isSystemKey(ID: currentViewID) == false {
          view.update(isSelected: true, forKeyID: currentViewID)
          view.setHintViewVisibleIfNeeded(true, forKeyID: currentViewID)

          if let currentViewID = currentViewID
            , self.shouldExpandInputOptionsImmediately(keyID: currentViewID) {
            self.expandInputOptionsIfNeeded(keyID: currentViewID)
          }
        }
      },
      onEnd: { touchData in
        D.logInfo("onEnd")

        // Clean began key
        view.update(isSelected: false, forKeyID: touchData.beganViewID)
        view.setHintViewVisibleIfNeeded(false, forKeyID: touchData.beganViewID)

        // Touch state AND hint view
        view.update(isSelected: false, forKeyID: touchData.currentViewID)
        view.setHintViewVisibleIfNeeded(false, forKeyID: touchData.currentViewID)

        // Input view
        if view.isInputOptionsVisible {
          if let ID = view.inputOptionSelection {
            self.enterLetter(ID: ID)
          }

          view.hideInputOptionsView()
        } else {
          // Enter text
          if let currentViewID = touchData.currentViewID,
            self.isSystemKey(ID: currentViewID) == false {
            self.enterLetter(ID: currentViewID)
          }
        }
    }))
  }

  fileprivate func shouldExpandInputOptionsImmediately(keyID ID: String) -> Bool {
    let string = layoutData.inputString(forLetterID: ID)
    return (string.characters.count == 0)
  }

  fileprivate func expandInputOptionsIfNeeded(keyID ID: String) {
    guard let view = self.view else { return }

    if view.isInputOptionsVisible ||
      (view.isOnTopRow(keyID: ID) && showTopRowKeyDownHintView) {
      return
    }

    if let inputOptionIDs = self.layoutData.inputOptions(forLetterID: ID)
      , inputOptionIDs.count > 0 {
      // Touch state AND hint view
      view.update(isSelected: false, forKeyID: ID)
      view.setHintViewVisibleIfNeeded(false, forKeyID: ID)

      // Input options
      let optionModels = inputOptionIDs.map({ (ID: String) -> KeyDownMenuOption in
        KeyDownMenuOption(
          ID: ID,
          displayString: self.layoutData.displayString(forLetterID: ID))
      })
      let model = KeyDownMenuModel(
        options: optionModels,
        defaultOptionID: nil)

      view.showOptionsView(model: model, keyID: ID)
    }
  }

  fileprivate func addTouchHandler(_ touchHandler: TouchHandler?) {
    guard let touchHandler = touchHandler,
      let touch = touchHandler.touch else {
      return
    }
    
    if touchHandlerMap[touch] == nil {
      touchHandlerMap[touch] = []
    }
    
    touchHandlerMap[touch]!.insert(touchHandler)
  }

  fileprivate func cancelAllTouchHandlers() {
    touchHandlerMap.forEach {
      $1.forEach { $0.touchEnded() }
    }
    touchHandlerMap.removeAll()
  }

  // MARK: Enter Letter
  fileprivate func enterLetter(ID: String) {
    // Need to separate system backward delete and user backward delete.
    let currLetter = layoutData.inputString(forLetterID: ID)

    var enterCharNormally: Bool = true
    var combinedLetter: String!

    if lastLetter != nil && (lastLetter!).characters.count > 0 {

      combinedLetter = (lastLetter! + currLetter).precomposedStringWithCompatibilityMapping

      if combinedLetter.characters.count > 1 {
        // For example, "ελ"
        enterCharNormally = true
      } else {
        let char = (combinedLetter as NSString).character(at: 0)

        if layoutData.isValidCombination(character: char) {
          // For example, "ὲ"
          enterCharNormally = false
        } else if D.shouldTestCombinedLetter {
          // For example, "ε``"
          enterCharNormally = true
        }
      }
    }

    if enterCharNormally {
      let letter = currLetter.precomposedStringWithCompatibilityMapping
      enterText(letter)
    } else {
      deleteBackwards()
      enterText(combinedLetter)
    }

    if state == .Uppercase {
      updateKeyboardState(.Lowercase)
    }
  }

  // MARK: Update state
  func forceUpdateKeyboard() {
    updateKeyboardState(state, isForceUpdate: true)
  }

  fileprivate func updateKeyboardState(
    _ newState: KeyboardState,
    isForceUpdate: Bool = false) {
    D.logInfo("updateKeyboardState")

    cancelAllTouchHandlers()

    if state == newState &&
      isForceUpdate == false {
      return
    }

    previousState = state
    _state = newState

    // Update key board touch area
    var nameState = state
    if nameState == .CapsLocked {
      nameState = .Uppercase
    }

    guard let layout = layoutData.layoutRows(forStateID: nameState.rawValue) else {
      return
    }

    let keyArrangementRows = createKeyArrangementRows(layoutRows: layout as [[AnyObject]])
    updateKeysInView(keyArrangementRows: keyArrangementRows)
  }

  // MARK: Keyboard layout related
  fileprivate func isSystemKey(ID: String?) -> Bool {
    guard let ID = ID else {
      return false
    }
    return SystemKeyFunction(rawValue: ID) != nil
  }

  func updateKeyboardWithLayoutStyleName(_ layoutStyleName: String) {

    layoutData.setUp(layoutStyle: layoutStyleName)
    settings.keyboardLayoutStyle = layoutStyleName

    forceUpdateKeyboard()
  }

  // MARK: Visual layout related
  fileprivate func visualArrangementOptions(systemKeyID ID: String) -> [KeyVisualArrangementOption]? {
    guard let view = view else { return nil }

    let constants = view.constants
    let keyboardWidth = view.bounds.width

    let defaultSystemKeyWidth = 40.0 / 320.0 * keyboardWidth

    if systemKeyVisualArrangementOptionsMapping == nil {
      let defaultDoneKeyWidth = 74.0 / 320.0 * keyboardWidth

      let thirdRowShared: [KeyVisualArrangementOption] = [
        .widthRatioToRegular(ratio: constants.normalSystemKeyRatio),
        .maxWidth(amount: defaultSystemKeyWidth),
      ]

      systemKeyVisualArrangementOptionsMapping = [
        SystemKeyFunction.Space.rawValue: [.flexGrow],
        SystemKeyFunction.ShiftSwitch.rawValue: thirdRowShared,
        SystemKeyFunction.Delete.rawValue: thirdRowShared,
        SystemKeyFunction.Done.rawValue: [
          .widthRatioToRegular(ratio: constants.extraWideSystemKeyRatio),
          .exactWidth(amount: defaultDoneKeyWidth),
        ],
      ]
    }

    return systemKeyVisualArrangementOptionsMapping[ID] ?? [
      .widthRatioToRegular(ratio: constants.normalSystemKeyRatio),
      .exactWidth(amount: defaultSystemKeyWidth),
    ]
  }

  fileprivate func createKeyArrangementRows(layoutRows: [[AnyObject]]) -> [KeyVisualArrangementRow] {
    
    var keyArrangementRows: [KeyVisualArrangementRow] = []

    layoutRows.forEach { (layoutRow: [AnyObject]) in
      let currentRow = KeyVisualArrangementRow()
      keyArrangementRows.append(currentRow)

      for layout in layoutRow {
        guard let ID = layout as? String else {
          continue
        }

        if ID.hasPrefix("SYSTEM KEY") {
          let arrangement = KeyVisualArrangement(
            ID: ID,
            options: visualArrangementOptions(systemKeyID: ID))
          arrangement.isSystemKey = true

          currentRow.appendToLastGroup(arrangement)
        } else if ID == "SYSTEM - LAYOUT GROUP DIVIDER" {
          currentRow.appendNewGroup()
        } else {
          let arrangement = KeyVisualArrangement(
            ID: ID,
            options: nil)
          arrangement.isSystemKey = false

          currentRow.appendToLastGroup(arrangement)
        }
      }

      if currentRow.groups.count == 2 {
        currentRow.groups[0].alignment = .center
        currentRow.groups[1].alignment = .trailing
      } else if currentRow.groups.count == 3 {
        currentRow.groups[0].alignment = .leading
        currentRow.groups[1].alignment = .center
        currentRow.groups[2].alignment = .trailing
      }
    }

    return keyArrangementRows
  }

  fileprivate func updateKeysInView(keyArrangementRows: [KeyVisualArrangementRow]) {
    guard let view = view else { return }

    let totalKeyboardSize = view.totalKeyboardSize

    let c = view.constants
    
    let visualArrangement = KeyboardVisualArrangement(
      bounds: CGRect(
        origin: CGPoint.zero,
        size: CGSize(width: totalKeyboardSize.width, height: c.keyboardKeysViewHeight)
      ),
      spaceInBetweenKeys: c.spaceInBetweenKeys,
      spaceInBetweenRows: c.spaceInBetweenRows,
      keyboardInset: c.keyboardInset,
      regularKeyWidth: -1,
      keyArrangementRows: keyArrangementRows
    )

    view.updateWith(keyboardVisualArrangement: visualArrangement)
  }

  // MARK: Update text
  fileprivate func deleteBackwards() {
    lastLetter = nil
    typer?.deleteBackward()
  }

  fileprivate func enterText(_ text: String) {
    lastLetter = nil
    typer?.insertText(text)
  }
}

extension KeyboardViewModel: TouchHandlerDelegate {
  func touchHandler(_: TouchHandler, viewIDForPoint point: CGPoint) -> String? {
    return view?.keyID(pointInKeysView: point)
  }

  func touchHandlerDidFinish(_ touchHandler: TouchHandler) {
    if let touch = touchHandler.touch {
      touchHandlerMap[touch]?.remove(touchHandler)
    }
  }
}

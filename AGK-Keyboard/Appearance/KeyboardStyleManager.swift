//
//  KeyboardStyleManager.swift
//  AGK
//
//  Created by Yichi on 2/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

class KeyboardStyleManager {
  fileprivate(set) var keyboardBackgroundColor: UIColor!
  fileprivate(set) var wordSuggestionsViewBackgroundColor: UIColor!
  fileprivate(set) var wordSuggestionSeparatorColor: UIColor!

  fileprivate(set) var keyColor: UIColor!
  fileprivate(set) var keyTextColor: UIColor!
  fileprivate(set) var keyShadowColor: UIColor!
  fileprivate(set) var keyHighlightedColor: UIColor!

  fileprivate(set) var systemKeyColor: UIColor!
  fileprivate(set) var systemKeyShadowColor: UIColor!
  fileprivate(set) var systemKeyHighlightedColor: UIColor!

  fileprivate(set) var systemKeyNoChangeStyle: KeyButtonStyle!
  fileprivate(set) var systemKeyHasChangeStyle: KeyButtonStyle!
  fileprivate(set) var systemKeyHasChangeReversedStyle: KeyButtonStyle!
  fileprivate(set) var systemKeyShiftOnStyle: KeyButtonStyle!
  fileprivate(set) var systemKeyActionButtonStyle: KeyButtonStyle!
  fileprivate(set) var moreSymbolKeyStyle: KeyButtonStyle!

  var textStyle: KeyboardTextStyle!

  init(
    appearance: UIKeyboardAppearance,
    mainFontName: String?,
    prefersBoldMainFont: Bool) {
    textStyle = KeyboardTextStyle()

    textStyle.mainFontName = mainFontName
    textStyle.prefersBoldMainFont = prefersBoldMainFont

    let actionButtonBlue = UIColorCreateWithRGB(0, 122, 255)
    let systemKeyTextFont = textStyle.systemKeyText.font

    if appearance == .dark {
      let backgroundGray = UIColorCreateWithRGB(20)
      let whiteColor = UIColor.white
      let mercury = UIColorCreateWithRGB(213) // Shift key selected/capslock bg
      let lightGray = UIColorCreateWithRGB(90) // Letter Key normal background
      let darkGray = UIColorCreateWithRGB(53) // System Key normal background
      let blackColor = UIColor.black
      let keyShadowColor = UIColor.black

      systemKeyNoChangeStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: whiteColor,
        backgroundColor: darkGray)

      systemKeyHasChangeStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: whiteColor,
        backgroundColor: darkGray,
        selectedBackgroundColor: lightGray)

      systemKeyHasChangeReversedStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: whiteColor,
        backgroundColor: lightGray,
        selectedBackgroundColor: darkGray)

      systemKeyShiftOnStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: blackColor,
        backgroundColor: mercury)

      systemKeyActionButtonStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: whiteColor,
        backgroundColor: actionButtonBlue,
        selectedForegroundColor: whiteColor,
        selectedBackgroundColor: lightGray)

      moreSymbolKeyStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: whiteColor,
        backgroundColor: lightGray)

      keyboardBackgroundColor = backgroundGray
      wordSuggestionsViewBackgroundColor = backgroundGray
      wordSuggestionSeparatorColor = UIColor.darkGray

      keyColor = lightGray
      keyTextColor = whiteColor
      self.keyShadowColor = keyShadowColor
      keyHighlightedColor = UIColorCreateWithRGB(35)

      systemKeyColor = darkGray
      systemKeyShadowColor = UIColorCreateWithRGB(0, 0, 0)
      systemKeyHighlightedColor = UIColorCreateWithRGB(209)
    } else {
      let backgroundGray = UIColorCreateWithRGB(209, 213, 219)
      let whiteColor = UIColor.white
      let blackColor = UIColor.black
      let darkGray = UIColorCreateWithRGB(172, 179, 188)
      let keyShadowColor = UIColorCreateWithRGB(136, 138, 142)

      systemKeyNoChangeStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: blackColor,
        backgroundColor: darkGray)

      systemKeyHasChangeStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: blackColor,
        backgroundColor: darkGray,
        selectedBackgroundColor: whiteColor)

      systemKeyHasChangeReversedStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: blackColor,
        backgroundColor: whiteColor,
        selectedBackgroundColor: darkGray)

      systemKeyShiftOnStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: blackColor,
        backgroundColor: whiteColor)

      systemKeyActionButtonStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: whiteColor,
        backgroundColor: actionButtonBlue,
        selectedForegroundColor: blackColor,
        selectedBackgroundColor: whiteColor)

      moreSymbolKeyStyle = KeyButtonStyle(
        font: systemKeyTextFont,
        foregroundColor: blackColor,
        backgroundColor: whiteColor)

      keyboardBackgroundColor = backgroundGray
      wordSuggestionsViewBackgroundColor = backgroundGray
      wordSuggestionSeparatorColor = UIColorCreateWithRGB(30)

      keyColor = UIColorCreateWithRGB(255)
      keyTextColor = UIColorCreateWithRGB(0)
      self.keyShadowColor = keyShadowColor
      keyHighlightedColor = UIColorCreateWithRGB(214) // iPad only?

      systemKeyColor = UIColorCreateWithRGB(172, 179, 188)
      systemKeyShadowColor = UIColorCreateWithRGB(136, 130, 142)
      systemKeyHighlightedColor = UIColorCreateWithRGB(255)
    }
  }

  func createKeyStyle() -> KeyButtonStyle {
    let keyStyle = KeyButtonStyle(
      font: textStyle.keyText.font,
      foregroundColor: keyTextColor,
      backgroundColor: keyColor,
      selectedForegroundColor: keyTextColor,
      selectedBackgroundColor: keyHighlightedColor,
      shadowColor: keyShadowColor)
    return keyStyle
  }

  func updateFontSizesWithScreenSize(_ screenSize: CGSize) {
    textStyle.updateWithScreenSize(screenSize)
  }
}

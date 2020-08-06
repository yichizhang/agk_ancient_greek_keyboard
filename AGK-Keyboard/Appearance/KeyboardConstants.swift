//
//  KeyboardConstants.swift
//  AGK
//
//  Created by Yichi on 10/08/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

struct KeyboardConstants {

  var spaceInBetweenKeys: CGFloat
  var spaceInBetweenRows: CGFloat

  var normalSystemKeyRatio: CGFloat // Width to Height
  var extraWideSystemKeyRatio: CGFloat // Width to Height

  var keyboardInset: UIEdgeInsets

  var keyboardTotalHeight: CGFloat
  var wordSuggestionsRowHeight: CGFloat
  var keyboardKeysViewHeight: CGFloat
}

struct KeyboardConstantsFactory {

  private static var isPad: Bool {
    return (UIDevice.current.userInterfaceIdiom == .pad)
  }
  
  static func create(
    totalKeyboardSize: CGSize,
    hasWordSuggestionsRow: Bool
  ) -> KeyboardConstants {

    D.logInfo("Creating KeyboardConstants for size \(totalKeyboardSize)")
    
    let topInset: CGFloat
    let sideInset: CGFloat
    let bottomInset: CGFloat
    let spaceInBetweenKeys: CGFloat
    let spaceInBetweenRows: CGFloat
    
    if isPad {
      topInset = 6
      sideInset = 6
      bottomInset = 6
      spaceInBetweenKeys = 9
      spaceInBetweenRows = 9
    }
    else {
      topInset = 4
      sideInset = 3
      bottomInset = 4
      spaceInBetweenKeys = 3
      spaceInBetweenRows = 3
    }

    let keyboardTotalHeight = totalKeyboardSize.height
    let wordSuggestionsRowHeight = hasWordSuggestionsRow ? floor(keyboardTotalHeight / 4.8) : 0
    let keyboardKeysViewHeight = keyboardTotalHeight - wordSuggestionsRowHeight

    return KeyboardConstants(
      spaceInBetweenKeys: spaceInBetweenKeys,
      spaceInBetweenRows: spaceInBetweenRows,
      normalSystemKeyRatio: 1.3,
      extraWideSystemKeyRatio: 1.6,
      keyboardInset: UIEdgeInsets.init(top: topInset, left: sideInset, bottom: bottomInset, right: sideInset),
      keyboardTotalHeight: keyboardTotalHeight,
      wordSuggestionsRowHeight: wordSuggestionsRowHeight,
      keyboardKeysViewHeight: keyboardKeysViewHeight
    )
  }
  
  static func recommendedTotalKeyboardSize(
    forContainerSize containerSize: CGSize,
    hasWordSuggestionsRow: Bool
  ) -> CGSize {

    D.logInfo("containerSize = \(containerSize)")

    var height: CGFloat = 0

    if containerSize.width > containerSize.height {
      height = containerSize.height * 0.4
    } else {
      height = containerSize.width * (isPad ? 0.3 : 0.618)
    }

    let factor: CGFloat = hasWordSuggestionsRow ? 1.25 : 1
    
    return CGSize(
      width: containerSize.width,
      height: height * factor
    )
  }
}

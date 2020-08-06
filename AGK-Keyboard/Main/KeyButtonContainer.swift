//
//  Created by Yichi Zhang on 10/07/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class KeyButtonContainer {
  fileprivate var keyButtons: [String: KeyButton] = [:]
  fileprivate var keyButtonGrid: [[[KeyButton]]] = []

  func removeAll() {
    keyButtons.removeAll(keepingCapacity: true)
    keyButtonGrid.removeAll(keepingCapacity: true)
  }

  subscript(ID: String) -> KeyButton? {
    get {
      return keyButtons[ID]
    }
    set {
      keyButtons[ID] = newValue

      if let button = newValue {
        insertToGrid(button)
      }
    }
  }

  func keyID(point: CGPoint) -> String? {
    let gridIndex = gridIndexForPoint(point)

    guard let candidates = candidatesAtGrid(x: gridIndex.x, y: gridIndex.y) else {
      return nil
    }

    for button in candidates {
      if button.frame.contains(point) {
        return button.ID
      }
    }

    return nil
  }

  func gridIndexForPoint(_ point: CGPoint) -> (x: Int, y: Int) {
    // TODO: These values may be improved
    return (Int(point.x / 20), Int(point.y / 30))
  }

  func insertToGrid(_ button: KeyButton) {
    let gridIndexBegin = gridIndexForPoint(button.frame.origin)
    let gridIndexEnd = gridIndexForPoint(CGPoint(x: button.frame.maxX, y: button.frame.maxY))

    for x in gridIndexBegin.0 ... gridIndexEnd.0 {
      for y in gridIndexBegin.1 ... gridIndexEnd.1 {
        insertToGrid(x: x, y: y, button: button)
      }
    }
  }

  func insertToGrid(x: Int, y: Int, button: KeyButton) {
    while keyButtonGrid.count <= x {
      keyButtonGrid.append([[]])
    }

    while keyButtonGrid[x].count <= y {
      keyButtonGrid[x].append([])
    }

    keyButtonGrid[x][y].append(button)
  }

  func candidatesAtGrid(x: Int, y: Int) -> [KeyButton]? {
    if x < 0 || x >= keyButtonGrid.count {
      return nil
    }

    if y < 0 || y >= keyButtonGrid[x].count {
      return nil
    }

    return keyButtonGrid[x][y]
  }
}

extension KeyButtonContainer: Sequence {
  func makeIterator() -> DictionaryIterator<String, KeyButton> {
    return keyButtons.makeIterator()
  }
}

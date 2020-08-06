//
//  Created by Yichi Zhang on 2017-10-28.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

protocol KeyboardLayoutDataProvider {

  func setUp(layoutStyle: String)
  func hasDisplayString(letterID: String) -> Bool
  func displayString(forLetterID letterID: String) -> String
  func inputOptions(forLetterID letterID: String) -> [String]?
  func inputString(forLetterID letterID: String) -> String
  func layoutRows(forStateID stateID: String) -> [[AnyObject]]?

  func isValidCombination(character: unichar) -> Bool
}

//
//  Created by Yichi Zhang on 2017-11-03.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class KeyboardStyleSelectionController: KeyboardPreviewController {
  
  var row: StringPushRow!
  
  private var appSettings: AppSettings {
    return AppSettings.shared
  }
  
  override func createSelectionViewController() -> UIViewController {
    return KeyboardStyleForm(style: .grouped).then { $0.delegate = self }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Style"
  }
  
  override func updateKeyboardPreview() {
    row.value = appSettings.keyboardLayoutStyle
    row.updateCell()
    
    super.updateKeyboardPreview()
  }
}

class KeyboardStyleForm: FormViewController {
  
  weak var delegate: CanUpdateKeyboardPreview?
  
  private var appSettings: AppSettings {
    return AppSettings.shared
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpForm()
  }
  
  private func setUpForm() {
    form
      +++ createStyleSection()
  }
  
  private func createStyleSection() -> Section {
    
    let section = SelectableSection<ListCheckRow<String>>(
        "Keyboard style",
        selectionType: .singleSelection(enableDeselection: false))
    
    for option in KeyboardLayoutStyle.allValues {
      section <<< ListCheckRow<String>(option) { row in
        row.title = option
        row.selectableValue = option
        row.value = (option == self.appSettings.keyboardLayoutStyle) ? option : nil
      }
    }
    
    section.onSelectSelectableRow = { [weak self] _, row in
      guard let me = self else { return }
      guard let v = row.value else { return }
      
      me.appSettings.keyboardLayoutStyle = v
      me.delegate?.updateKeyboardPreview()
    }
    
    return section
  }
}

//
//  Created by Yichi Zhang on 2017-11-04.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import Eureka
import SwiftyUserDefaults

typealias StringPushRow = CustomPushRowOf<String>

struct ListOption {
  
  var value: String
  var displayName: String
  
  init(value: String) {
    self.value = value
    displayName = value
  }
  
  init(value: String, displayName: String) {
    self.value = value
    self.displayName = displayName
  }
}

extension FormViewController {
  
  // MARK: Switch
  func createSwitchCell(
    title: String,
    key: DefaultsKey<Bool?>,
    appSettings: AppSettings = AppSettings.shared
    ) -> SwitchRow {
    return
      SwitchRow() {
        $0.title = title
        $0.value = appSettings.boolValue(forKey: key)
        }.onChange({ (r: SwitchRow) in
          if let v = r.value {
            appSettings.set(bool: v, forKey: key)
          }
        })
  }
  
  // MARK: Custom push row
  func createStringPushCell(
    title: String,
    key: DefaultsKey<String?>,
    appSettings: AppSettings = AppSettings.shared,
    createVC: @escaping ((StringPushRow) -> UIViewController)
    ) -> StringPushRow {
    
    return StringPushRow() { row in
      
      row.value = appSettings.stringValue(forKey: key)
      row.title = title
      
      row.displayValueFor = { (s: String?) -> String? in
        return s
      }
      
      row.presentationMode = .show(
        controllerProvider: ControllerProvider.callback {
          return createVC(row)
      }, onDismiss: nil)
      
      }.onChange { (row) in
        
        if let value = row.value {
          appSettings.set(string: value, forKey: key)
        }
        
        row.updateCell()
    }
  }
  
  // MARK: Create list selection
  typealias ListSectionCellUpdate = ((ListCheckCell<String>, String) -> Void)
  typealias ListSectionSettingsUpdate = (() -> Void)
  
  func createListSection(
    title: String,
    key: DefaultsKey<String?>,
    options _options: [Any],
    appSettings: AppSettings = AppSettings.shared,
    onCellUpdate: @escaping ListSectionCellUpdate = { _, _ in },
    onSettingsUpdate: @escaping ListSectionSettingsUpdate
    ) -> Section {
    
    let section = SelectableSection<ListCheckRow<String>>(
      title,
      selectionType: .singleSelection(enableDeselection: false)
    )
    
    let options = _options.compactMap { (any) -> ListOption? in
      if let option = any as? ListOption {
        return option
      }
      else if let stringOption = any as? String {
        return ListOption(value: stringOption)
      }
      return nil
    }
    
    for option in options {
      
      section <<< ListCheckRow<String>() { row in
        row.title = option.displayName
        row.selectableValue = option.value
        row.value = (option.value == appSettings.stringValue(forKey: key)) ? option.value : nil
        }
        .cellUpdate({ cell, row in
          guard let value = row.selectableValue else { return }
          
          onCellUpdate(cell, value)
        })
    }
    
    section.onSelectSelectableRow = { _, row in
      guard let value = row.value else { return }
      
      appSettings.set(string: value, forKey: key)
      onSettingsUpdate()
    }
    
    return section
  }
}

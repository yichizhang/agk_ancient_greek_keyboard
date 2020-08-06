//
//  SettingsViewController.swift
//  AGK
//
//  Created by Yichi on 8/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import Eureka

class SettingsViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Settings"

    setUpForm()
  }

  private func setUpForm() {
    form
      +++ createDefaultSection()
      +++ createAppearanceSection()
    
    if D.supportsWordSuggestionView {
      
      addAdvancedSection()
    }
  }
  
  private func createDefaultSection() -> Section {
    return Section()
      
      <<< createStringPushCell(title: "Style", key: .keyboardLayoutStyle) { row in
        KeyboardStyleSelectionController().then { $0.row = row }
      }
  }
  
  private func createAppearanceSection() -> Section {
    return Section("Appearance")
      
      <<< ButtonRow("Font") {
        $0.title = $0.tag
        $0.presentationMode = .show(
          controllerProvider: ControllerProvider.callback {
            KeyboardFontSelectionController()
        }, onDismiss: nil)
    }
  }
  
  private func addAdvancedSection() {
    form +++
      Section("Advanced")
      
      <<< createSwitchCell(title: "Show lowercase keys", key: .showLowercaseKeys)
    
    if D.supportsWordSuggestionView {
      
      let footer = "The system does not allow third party keyboard apps to draw above the keyboard area, therefore displaying multiple input options for keys in the first row will not work correctly. Applying a workaround by showing an extra row above the keys."
      
      form +++
        Section(footer: footer)
        
        <<< createSwitchCell(title: "Show an extra blank row", key: .showWordSuggestionsView)
    }
  }
}

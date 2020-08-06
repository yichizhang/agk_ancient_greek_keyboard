//
//  MenuViewController.swift
//  AGK
//
//  Created by Yichi on 8/07/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import Eureka

class MenuViewController: FormViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Home"
    
    navigationOptions = RowNavigationOptions.Disabled
    
    setUpForm()
  }

  private func setUpForm() {
    form
      +++ createAboutSection()
      +++ createGuidesSection()
      +++ createSettingsSection()
  }

  private func createAboutSection() -> Section {
    let section = Section()

    section <<< AppLogoRow { row in
      row.value = AppDetails.shared.aboutString(separator: "\n", includesVersion: false)
    }

    section <<< createButtonRow(
      title: "Test the keyboard",
      pushing: TestKeyboardViewController.self
    )

    if D.isDebug && !D.isRunningUITests {
      
      section <<< createButtonRow(
        title: "Test keyboard types",
        pushing: TestKeyboardTypesViewController.self
      )
      
      section <<< createButtonRow(
        title: "Test text styles",
        pushing: TestTextStylesViewController.self
      )
      
      section <<< createButtonRow(
        title: "Debug keyboard layout",
        pushing: DebugKeyboardLayoutViewController.self
      )
    }
    
    return section
  }

  private func createGuidesSection() -> Section {
    return Section("Guides")
      
      <<< createButtonRow(
        title: "Use AGK as system keyboard",
        pushing: AddKeyboardGuideViewController.self
    )
  }

  private func createSettingsSection() -> Section {
    return Section()

      <<< createButtonRow(
        title: "Settings",
        pushing: SettingsViewController.self)

      <<< createButtonRow(
        title: "About",
        pushing: AboutViewController.self)
  }

  func createButtonRow(
    title: String,
    pushing viewControllerClass: UIViewController.Type
  ) -> ButtonRow {
    return ButtonRow(title) { row in
      row.title = row.tag
      row.presentationMode = .show(
        controllerProvider: ControllerProvider.callback {
          viewControllerClass.init()
      }, onDismiss: nil)
    }
  }

  func createButtonRow(
    title: String,
    pushing createViewController: @escaping (() -> UIViewController?)
  ) -> ButtonRow {
    return ButtonRow(title) { row in
      row.title = row.tag
      row.presentationMode = .show(
        controllerProvider: ControllerProvider.callback {
          createViewController()!
      }, onDismiss: nil)
    }
  }
}

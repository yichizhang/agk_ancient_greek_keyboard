//
//  TestKeyboardTypesViewController.swift
//  AGK
//
//  Created by Yichi on 9/09/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit
import Eureka

class TestKeyboardTypesViewController: FormViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Keyboard Types"
    
    setUpForm()
  }
  
  private func setUpForm() {
    form
      +++ createKeyboardAppearanceSection()
      +++ createKeyboardTypesSection()
  }
  
  private func createKeyboardAppearanceSection() -> Section {
    let section = Section("Keyboard appearance")
    
    for option in keyboardAppearanceModels {
      section <<< TextRow(option.title) { row in
        row.title = option.title
        }
        .cellSetup { cell, _ in
          cell.textField.keyboardAppearance = option.appearance
      }
    }
    
    return section
  }
  
  private func createKeyboardTypesSection() -> Section {
    let section = Section("Keyboard types")
    
    for option in keyboardTypeModels {
      section <<< TextRow(option.title) { row in
        row.title = option.title
        }
        .cellSetup { cell, _ in
          cell.textField.keyboardType = option.keyboardType
      }
    }
    
    return section
  }
  
  // MARK: Keyboard appearance
  private struct KeyboardAppearanceModel {
    var title: String!
    var appearance: UIKeyboardAppearance!
  }
  
  private lazy var keyboardAppearanceModels: [KeyboardAppearanceModel] = {
    return [
      KeyboardAppearanceModel(
        title: "default",
        appearance: .default
      ),
      KeyboardAppearanceModel(
        title: "light",
        appearance: .light
      ),
      KeyboardAppearanceModel(
        title: "dark",
        appearance: .dark
      ),
      ]
  }()
  
  // MARK: Keyboard type
  private struct KeyboardTypeModel {
    var title: String!
    var keyboardType: UIKeyboardType!
  }
  
  private lazy var keyboardTypeModels: [KeyboardTypeModel] = {
    return [
      KeyboardTypeModel(
        title: "ASCIICapable",
        keyboardType: .asciiCapable),
      KeyboardTypeModel(
        title: "ASCIICapableNumberPad",
        keyboardType: .asciiCapableNumberPad),
      KeyboardTypeModel(
        title: "DecimalPad",
        keyboardType: .decimalPad),
      KeyboardTypeModel(
        title: "Default",
        keyboardType: .default),
      KeyboardTypeModel(
        title: "EmailAddress",
        keyboardType: .emailAddress),
      KeyboardTypeModel(
        title: "NamePhonePad",
        keyboardType: .namePhonePad),
      KeyboardTypeModel(
        title: "NumberPad",
        keyboardType: .numberPad),
      KeyboardTypeModel(
        title: "NumbersAndPunctuation",
        keyboardType: .numbersAndPunctuation),
      KeyboardTypeModel(
        title: "PhonePad",
        keyboardType: .phonePad),
      KeyboardTypeModel(
        title: "Twitter",
        keyboardType: .twitter),
      KeyboardTypeModel(
        title: "URL",
        keyboardType: .URL),
      KeyboardTypeModel(
        title: "WebSearch",
        keyboardType: .webSearch),
      ]
  }()
}

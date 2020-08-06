//
//  Created by Yichi Zhang on 25/08/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Eureka

protocol FontSelectionFormDelegate: class {
  
  func formDidUpdate()
}

class FontSelectionForm: FormViewController {
  
  weak var delegate: FontSelectionFormDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if D.isRunningUITests {
      
      AppSettings.shared.set(string: "AGKSystemFont", forKey: .mainFontFamily)
      AppSettings.shared.set(string: KeyboardFontWeight.Regular, forKey: .mainFontWeight)
    }
    
    setUpForm()
  }
  
  private func setUpForm() {
    form
      +++ createFontWeight()
      +++ createFontFamily()
  }
  
  private func createFontWeight() -> Section {
    let options: [String] = [
      KeyboardFontWeight.Regular,
      KeyboardFontWeight.Bold,
      ]
    
    return createListSection(
      title: "Font weight",
      key: .mainFontWeight,
      options: options,
      onSettingsUpdate: { [weak self] in
        self?.delegate?.formDidUpdate()
    })
  }
  
  private func createFontFamily() -> Section {
    let options: [Any] = [
      ListOption(
        value: "AGKSystemFont",
        displayName: "System font"
      ),
      "Helvetica",
      "Helvetica Neue",
      "Palatino",
      "Times New Roman",
      "Trebuchet MS",
      ]
    
    return createListSection(
      title: "Font family",
      key: .mainFontFamily,
      options: options,
      onCellUpdate: {
        $0.textLabel?.font = UIFont.yz_create(
          family: $1,
          style: .body
        )
    },
      onSettingsUpdate: { [weak self] in
        self?.delegate?.formDidUpdate()
    })
  }
}

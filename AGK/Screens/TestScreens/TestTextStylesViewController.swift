//
//  Created by Yichi Zhang on 2017-02-23.
//  Copyright (c) 2017-present Yichi. All rights reserved.
//

import UIKit
import Eureka

class TestTextStylesViewController: FormViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Text Styles"
    
    setUpForm()
  }
  
  private func setUpForm() {
    form
      +++ createTextStylesSection()
  }
  
  private func createTextStylesSection() -> Section {
    let section = Section("Text styles")
    
    for m in textStyleModels {
      let font = UIFont.yz_create(
        family: "Helvetica Neue",
        style: m.textStyle)
      
      section <<< LabelRow(m.title) { row in
        row.title = m.title + " " + "\(font?.pointSize ?? 0)"
        }
        .cellSetup { cell, _ in
          cell.textLabel?.font = font
      }
    }
    
    return section
  }
  
  private struct TextStyleModel {
    var title: String!
    var textStyle: UIFont.TextStyle!
  }
  
  private lazy var textStyleModels: [TextStyleModel] = {
    return [
      TextStyleModel(title: "title1", textStyle: .title1),
      TextStyleModel(title: "title2", textStyle: .title2),
      TextStyleModel(title: "title3", textStyle: .title3),
      TextStyleModel(title: "headline", textStyle: .headline),
      TextStyleModel(title: "subheadline", textStyle: .subheadline),
      TextStyleModel(title: "body", textStyle: .body),
      TextStyleModel(title: "callout", textStyle: .callout),
      TextStyleModel(title: "footnote", textStyle: .footnote),
      TextStyleModel(title: "caption1", textStyle: .caption1),
      TextStyleModel(title: "caption2", textStyle: .caption2),
      ]
  }()
}

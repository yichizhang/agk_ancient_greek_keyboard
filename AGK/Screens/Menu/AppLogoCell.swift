//
//  AppLogoTableCell.swift
//  AGK
//
//  Created by Yichi on 5/09/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit
import Eureka

public class AppLogoCell: Cell<String>, CellType {
  typealias Value = String

  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var aboutLabel: UILabel!

  open override func setup() {
    row.title = nil
    super.setup()
    selectionStyle = .none

    aboutLabel.font = UIFont.TextStyle.title3.font(isBold: true)
  }

  open override func update() {
    row.title = nil
    super.update()

    aboutLabel.text = row.value
  }
}

public final class AppLogoRow: Row<AppLogoCell>, RowType {

  public required init(tag: String?) {
    super.init(tag: tag)
    displayValueFor = nil
    cellProvider = CellProvider<AppLogoCell>(nibName: "AppLogoCell")
  }
}

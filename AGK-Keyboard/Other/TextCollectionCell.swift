//
//  Created by Yichi on 11/08/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

class TextCollectionCell: UICollectionViewCell {
  var textLabel: UILabel!

  func commonInit() {
    textLabel = UILabel()
    textLabel.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(textLabel)
    textLabel.ql_attribute(.centerX)
    textLabel.ql_attribute(.centerY)
  }

  override
  init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required
  init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
}

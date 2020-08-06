//
//  Created by YICHI ZHANG on 10/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class SetupAppAppearanceUseCase {
  func activate() {
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

    let barColor = UIColor.black
    let textColor = UIColor.white

    let navBarAppearance = UINavigationBar.appearance()
    navBarAppearance.barStyle = UIBarStyle.black
    navBarAppearance.isTranslucent = false
    navBarAppearance.backgroundColor = barColor
    navBarAppearance.tintColor = textColor
    navBarAppearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: textColor,
      NSAttributedString.Key.font: UIFont.TextStyle.title3.font(maxSizeFactor: 1.6, isBold: true),
    ]
  }
}

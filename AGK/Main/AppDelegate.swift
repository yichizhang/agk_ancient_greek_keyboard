//
//  Created by Yichi on 19/05/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    if window == nil {
      window = UIWindow(frame: UIScreen.main.bounds)
    }

    SetupAppAppearanceUseCase().activate()

    if let window = window {
      window.rootViewController = UINavigationController(rootViewController: MenuViewController()).then {
        $0.navigationBar.prefersLargeTitles = true
      }

      window.makeKeyAndVisible()
    }

    return true
  }
}

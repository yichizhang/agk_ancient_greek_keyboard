//
//  Created by Yichi Zhang on 13/08/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import Foundation

class AboutViewModel {
  fileprivate weak var viewController: AboutViewController?

  private var appDetails: AppDetails {
    return AppDetails.shared
  }

  var aboutText: NSAttributedString {
    let title = appDetails.aboutString(separator: " ", includesVersion: true)
    let content = "Developed by Yichi Zhang (zhang-yi-chi@hotmail.com) with help from Silvend Ikarus."

    let fgColor = UIColor.black
    let ret = NSMutableAttributedString()
    let paragraphStyle = NSMutableParagraphStyle()

    paragraphStyle.paragraphSpacing = 12
    paragraphStyle.lineSpacing = 8
    
    ret.append(
      NSAttributedString(
        string: title,
        attributes: [
          NSAttributedString.Key.foregroundColor: fgColor,
          NSAttributedString.Key.font: UIFont.TextStyle.title3.font(isBold: true),
          NSAttributedString.Key.paragraphStyle: paragraphStyle,
    ]))
    ret.append(
      NSAttributedString(
        string: "\n"))
    ret.append(
      NSAttributedString(
        string: content,
        attributes: [
          NSAttributedString.Key.foregroundColor: fgColor,
          NSAttributedString.Key.font: UIFont.TextStyle.headline.font,
          NSAttributedString.Key.paragraphStyle: paragraphStyle,
    ]))

    return NSAttributedString(attributedString: ret)
  }

  init(viewController: AboutViewController) {
    
    self.viewController = viewController
  }

  func didSelectSendFeedback() {
    viewController?.showMailComposer()
  }

  func didSelectWriteAReview() {
    let URLString = "itms-apps://itunes.apple.com/app/id1018791342"
    guard let URL = URL(string: URLString) else { return }
    guard UIApplication.shared.canOpenURL(URL) else { return }
    UIApplication.shared.open(URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

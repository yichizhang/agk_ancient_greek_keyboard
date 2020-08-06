//
//  Created by Yichi Zhang on 2017-02-22.
//  Copyright (c) 2017-present Yichi. All rights reserved.
//

import Foundation
import MessageUI

extension AboutViewController {
  func showMailComposer() {
    if MFMailComposeViewController.canSendMail() {
      let viewController = MFMailComposeViewController()
      viewController.mailComposeDelegate = self
      viewController.setSubject("AGK Keyboard Feedback")
      viewController.setMessageBody("", isHTML: false)
      viewController.setToRecipients(["zhang-yi-chi@hotmail.com"])
      present(viewController, animated: true, completion: nil)
    } else {
      let alertController = UIAlertController(
        title: "Can't send email",
        message: "It seems that your device does not support email.",
        preferredStyle: UIAlertController.Style.alert)
      alertController.addAction(
        UIAlertAction(
          title: "OK",
          style: UIAlertAction.Style.cancel,
          handler: nil))
      present(alertController, animated: true, completion: nil)
    }
  }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(
    _: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error _: Error?
  ) {
    let showThankYou = (result == MFMailComposeResult.sent)

    if showThankYou {
      dismiss(
        animated: true,
        completion: { [unowned self] () -> Void in
          let alertController = UIAlertController(
            title: "Thank you!",
            message: "Your feedback will help us make the app better.",
            preferredStyle: UIAlertController.Style.alert)
          alertController.addAction(
            UIAlertAction(
              title: "OK",
              style: UIAlertAction.Style.cancel,
              handler: nil))
          self.present(alertController, animated: true, completion: nil)
      })
    } else {
      dismiss(animated: true, completion: nil)
    }
  }
}

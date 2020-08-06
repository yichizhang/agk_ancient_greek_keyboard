//
//  Created by Yichi Zhang on 14/09/2016.
//  Copyright (c) 2016-present Yichi. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
  fileprivate(set) lazy var textView: UITextView = {
    let textView = UITextView(frame: CGRect.zero)
    textView.translatesAutoresizingMaskIntoConstraints = false

    textView.isEditable = false
    textView.isSelectable = true

    textView.backgroundColor = UIColorCreateWithRGB(239, 239, 244)

    return textView
  }()

  fileprivate var attributedText: NSAttributedString? {
    didSet {
      self.textView.attributedText = attributedText
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    textView.textContainerInset = UIEdgeInsets(uniform: 20.0)

    view.addSubview(textView)
    textView.ql_edges()
  }

  @objc
  fileprivate func dismissButtonTapped(_: AnyObject) {
    presentingViewController?.dismiss(animated: true, completion: nil)
  }

  class func createMoreInfoViewController(content: String) -> UIViewController {

    let viewController = TextViewController()
    viewController.title = "More info"

    viewController.attributedText = NSMutableAttributedString(
      string: content,
      attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont.TextStyle.body.font,
    ])

    viewController.navigationItem.leftBarButtonItem =
      UIBarButtonItem(
        title: "Close",
        style: .done,
        target: viewController,
        action: #selector(dismissButtonTapped(_:))
      )

    return UINavigationController(rootViewController: viewController).then {
      $0.navigationBar.prefersLargeTitles = true
    }
  }
}

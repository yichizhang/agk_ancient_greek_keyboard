//
//  AboutViewController.swift
//  AGK
//
//  Created by Yichi on 8/09/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import MessageUI
import Eureka

class AboutViewController: FormViewController {
  fileprivate var viewModel: AboutViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel = AboutViewModel(viewController: self)

    title = "About"
    
    navigationOptions = RowNavigationOptions.Disabled

    setUpForm()
  }

  private func setUpForm() {
    form
      +++ createInfoSection()
      +++ createActionsSection()
  }

  private func createInfoSection() -> Section {
    return Section()

      <<< TextAreaRow { row in
        row.textAreaHeight = .dynamic(initialTextViewHeight: 110)
      }
      .cellUpdate { [unowned self] (cell: TextAreaCell, _: TextAreaRow) in
        cell.textView.isScrollEnabled = false
        cell.textView.isEditable = false
        cell.textView.attributedText = self.viewModel.aboutText
      }
  }

  private func createActionsSection() -> Section {
    return Section()

      <<< ButtonRow("Give feedback") { row in
        row.title = row.tag
      }
      .onCellSelection { [weak self] _, _ in
        self?.viewModel.didSelectSendFeedback()
      }

      <<< ButtonRow("Write a review") { row in
        row.title = row.tag
      }
      .onCellSelection { [weak self] _, _ in
        self?.viewModel.didSelectWriteAReview()
      }
  }
}

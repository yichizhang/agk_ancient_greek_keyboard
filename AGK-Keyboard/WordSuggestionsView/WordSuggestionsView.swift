//
//  WordSuggestionsView.swift
//  AGK
//
//  Created by Yichi on 11/08/2015.
//  Copyright (c) 2015 Yichi. All rights reserved.
//

import Foundation
import UIKit

protocol WordSuggestionsViewDelegate: class {
  func wordSuggestionsViewKeyTapped(_ wordSuggestionsView: WordSuggestionsView, key: String)
}

class WordSuggestionsView: UIView {
  
  weak var delegate: WordSuggestionsViewDelegate?
  
  var textView: UITextView?
  
  init(frame: CGRect, delegate: WordSuggestionsViewDelegate? = nil) {
    super.init(frame: frame)

    if D.isDebug {
      let v = UITextView()
      self.textView = v
      
      addSubview(v)
      v.ql_edges()

      D.textView = textView
    }

    self.delegate = delegate
  }

  required
  init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

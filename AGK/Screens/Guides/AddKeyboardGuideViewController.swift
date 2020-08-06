//
//  Created by Yichi Zhang on 2017-11-02.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import UIKit
import Eureka

fileprivate extension TextStyle {
  
  static var normal: TextStyle { return UIFont.TextStyle.title3 }
}

fileprivate extension String {
  
  var normal: NSAttributedString {
    return self.styled(with: .normal)
  }
  
  var bold: NSAttributedString {
    return self.styled(with: .normal, isBold: true)
  }
}

class AddKeyboardGuideViewController: FormViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Guide"
    
    navigationOptions = RowNavigationOptions.Disabled
    
    setUpForm()
  }
  
  private func setUpForm() {
    
    itemNo = 1
    
    form
      +++ Section("How to add as system keyboard?")
      
      <<< create(parts: [
        "Open",
        UIImage(named: "SettingsApp_Icon"),
        "Settings".bold,
        "app"
        ])
      
      <<< create(parts: [
        "Go to",
        UIImage(named: "SettingsApp_General_Icon"),
        "General".bold
        ])
      
      <<< create(parts: [
        "Select",
        "Keyboard".bold
        ])
      
      <<< create(parts: [
        "Select",
        "Keyboards".bold
        ])
      
      <<< create(parts: [
        "Tap",
        "Add New Keyboard...".bold
        ])
      
      <<< create(parts: [
        "Choose",
        "AGK".bold,
        "under",
        "Third-party Keyboards".bold
        ])
  }
  
  private var itemNo = 1
  private func create(parts: [Any?]) -> TextAreaRow {
    return TextAreaRow() { row in
      row.textAreaHeight = TextAreaHeight.dynamic(initialTextViewHeight: 24)
      }.cellUpdate { (cell, row) in
        cell.textView.isScrollEnabled = false
        cell.textView.isEditable = false
        cell.textView.isUserInteractionEnabled = false
        
        let text = NSMutableAttributedString()
        
        text.append(NSAttributedString(
          string: self.text(itemNo: self.itemNo) + "\t",
          attributes: TextStyle.normal.attributes(additionalAttributes: [
            NSAttributedString.Key.paragraphStyle: NSMutableParagraphStyle().then {
              
              let location = CGFloat(33)
              $0.tabStops = [NSTextTab(textAlignment: NSTextAlignment.left, location: location, options: [:])]
              $0.headIndent = location
            }])))
        
        for p in parts {
          var added = false
          
          if let t = p as? String {
            text.append(t.normal)
            added = true
          }
          else if let a = p as? NSAttributedString {
            text.append(a)
            added = true
          }
          else if let i = p as? UIImage {
            let font = TextStyle.normal.font
            let imageSize = CGSize(width: 32, height: 32)
            let mid = font.descender + font.capHeight
            let textAttachmentBounds = CGRect(
              x: 0,
              y: font.descender - imageSize.height / 2 + mid + 2,
              width: imageSize.width,
              height: imageSize.height
            )
            
            text.append(NSAttributedString(attachment: NSTextAttachment().then {
              $0.image = i
              $0.bounds = textAttachmentBounds
            }))
            added = true
          }
          
          if added {
            text.append(" ".normal)
          }
        }
        
        cell.textView.attributedText = text
        
        self.itemNo += 1
    }
  }
  
  private func text(itemNo: Int) -> String {
    switch itemNo {
    case 0: return "⓪"
    case 1: return "①"
    case 2: return "②"
    case 3: return "③"
    case 4: return "④"
    case 5: return "⑤"
    case 6: return "⑥"
    case 7: return "⑦"
    case 8: return "⑧"
    case 9: return "⑨"
    case 10: return "⑩"
    case 11: return "⑪"
    case 12: return "⑫"
    case 13: return "⑬"
    case 14: return "⑭"
    case 15: return "⑮"
    case 16: return "⑯"
    case 17: return "⑰"
    case 18: return "⑱"
    case 19: return "⑲"
    case 20: return "⑳"
    default: return ""
    }
  }
}

//
//  Created by Yichi Zhang on 2017-11-03.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import Foundation
import Eureka

// NB: This is based on ButtonRow/ButtonCell

// MARK: CustomPushCell

open class CustomPushCellOf<T: Equatable>: Cell<T>, CellType {
  
  required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  open override func update() {
    super.update()
    selectionStyle = row.isDisabled ? .none : .default
    accessoryType = .none
    editingAccessoryType = accessoryType
    textLabel?.textAlignment = .center
    textLabel?.textColor = tintColor
    textLabel?.textColor  = tintColor.withAlphaComponent(row.isDisabled ? 0.3 : 1.0)
  }
  
  open override func didSelect() {
    super.didSelect()
    row.deselect()
  }
}

public typealias CustomPushCell = CustomPushCellOf<String>

// MARK: CustomPushRow

open class _CustomPushRowOf<T: Equatable> : Row<CustomPushCellOf<T>> {
  
  open var presentationMode: PresentationMode<UIViewController>?
  
  open var maxSelectionCount: Int = 3
  
  required public init(tag: String?) {
    super.init(tag: tag)
    displayValueFor = nil
    cellStyle = .value1
  }
  
  open override func customDidSelect() {
    super.customDidSelect()
    if !isDisabled {
      if let presentationMode = presentationMode {
        if let controller = presentationMode.makeController() {
          presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
        } else {
          presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
        }
      }
    }
  }
  
  open override func customUpdateCell() {
    super.customUpdateCell()
    let leftAligmnment = presentationMode != nil
    cell.textLabel?.textAlignment = leftAligmnment ? .left : .center
    cell.accessoryType = !leftAligmnment || isDisabled ? .none : .disclosureIndicator
    cell.editingAccessoryType = cell.accessoryType
    cell.textLabel?.textColor = !leftAligmnment ? cell.tintColor.withAlphaComponent(isDisabled ? 0.3 : 1.0) : nil
    
    cell.detailTextLabel?.text = displayValueFor?(value) ??
      (self as? NoValueDisplayTextConformance)?.noValueDisplayText
  }
  
  open override func prepare(for segue: UIStoryboardSegue) {
    super.prepare(for: segue)
    (segue.destination as? RowControllerType)?.onDismissCallback = presentationMode?.onDismissCallback
  }
}

/// A generic row with a button. The action of this button can be anything but normally will push a new view controller
public final class CustomPushRowOf<T: Equatable> : _CustomPushRowOf<T>, RowType {
  public required init(tag: String?) {
    super.init(tag: tag)
  }
}

/// A row with a button and String value. The action of this button can be anything but normally will push a new view controller
public typealias CustomPushRow = CustomPushRowOf<String>


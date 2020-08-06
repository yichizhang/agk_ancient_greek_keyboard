//
//  Copyright (c) 2017-present, Yichi Zhang.
//
//  This source code is licensed under the MIT-style license found
//  in the LICENSE file in the root directory of this source tree.
//

import UIKit

public struct EdgeConstraints {
  var top: NSLayoutConstraint?
  var left: NSLayoutConstraint?
  var bottom: NSLayoutConstraint?
  var right: NSLayoutConstraint?
}

extension EdgeConstraints {
  
  var topPadding: CGFloat {
    get {
      return top?.constant ?? 0
    }
    set {
      top?.constant = newValue
    }
  }
  
  var leftPadding: CGFloat {
    get {
      return left?.constant ?? 0
    }
    set {
      left?.constant = newValue
    }
  }
  
  var bottomPadding: CGFloat {
    get {
      return bottom?.constant ?? 0
    }
    set {
      bottom?.constant = newValue
    }
  }
  
  var rightPadding: CGFloat {
    get {
      return right?.constant ?? 0
    }
    set {
      right?.constant = newValue
    }
  }
  
  var inset: UIEdgeInsets {
    get {
      return UIEdgeInsets(
        top: topPadding,
        left: leftPadding,
        bottom: bottomPadding,
        right: rightPadding
      )
    }
    set {
      topPadding = newValue.top
      leftPadding = newValue.left
      bottomPadding = newValue.bottom
      rightPadding = newValue.right
    }
  }
}

public struct SizeConstraints {
  var width: NSLayoutConstraint?
  var height: NSLayoutConstraint?
}

public extension UIView {
  @discardableResult
  func ql_edges(
    _ edges: UIRectEdge = UIRectEdge.all,
    inSuperview _superview: UIView? = nil,
    relation: NSLayoutConstraint.Relation = .equal,
    insetH: CGFloat,
    insetV: CGFloat
    ) -> EdgeConstraints {
    let inset = UIEdgeInsets(top: insetV, left: insetH, bottom: insetV, right: insetH)
    return ql_edges(edges, inSuperview: _superview, relation: relation, inset: inset)
  }
  
  @discardableResult
  func ql_edges(
    _ edges: UIRectEdge = UIRectEdge.all,
    inSuperview _superview: UIView? = nil,
    relation: NSLayoutConstraint.Relation = .equal,
    uniformInset i: CGFloat
    ) -> EdgeConstraints {
    return ql_edges(
      edges,
      inSuperview: _superview,
      relation: relation,
      inset: UIEdgeInsets(top: i, left: i, bottom: i, right: i))
  }
  
  @discardableResult
  func ql_edges(
    _ edges: UIRectEdge = UIRectEdge.all,
    inSuperview _superview: UIView? = nil,
    relation: NSLayoutConstraint.Relation = .equal,
    inset: UIEdgeInsets = UIEdgeInsets.zero
    ) -> EdgeConstraints {
    translatesAutoresizingMaskIntoConstraints = false
    
    let superview = _superview ?? self.superview!
    
    var constraints = EdgeConstraints()
    
    if edges.contains(.top) {
      constraints.top =
        ql_attribute(.top, relation: relation, constant: inset.top)
    }
    if edges.contains(.left) {
      constraints.left =
        ql_attribute(.leading, relation: relation, constant: inset.left)
    }
    if edges.contains(.bottom) {
      switch relation {
      case .lessThanOrEqual:
        constraints.bottom = superview.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: inset.bottom)
      case .greaterThanOrEqual:
        constraints.bottom = superview.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: inset.bottom)
      default:
        constraints.bottom = superview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: inset.bottom)
      }
      constraints.bottom?.isActive = true
    }
    if edges.contains(.right) {
      switch relation {
      case .lessThanOrEqual:
        constraints.right = superview.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: inset.right)
      case .greaterThanOrEqual:
        constraints.right = superview.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor, constant: inset.right)
      default:
        constraints.right = superview.rightAnchor.constraint(equalTo: rightAnchor, constant: inset.right)
      }
      constraints.right?.isActive = true
    }
    
    return constraints
  }
  
  @discardableResult
  func ql_attribute(
    _ attribute: NSLayoutConstraint.Attribute,
    relation: NSLayoutConstraint.Relation? = nil,
    toView: UIView? = nil,
    on toViewAttribute: NSLayoutConstraint.Attribute? = nil,
    multiplier: CGFloat = 1.0,
    constant: CGFloat = 0.0,
    priority: UILayoutPriority = UILayoutPriority.required
    ) -> NSLayoutConstraint {
    translatesAutoresizingMaskIntoConstraints = false
    
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: attribute,
      relatedBy: relation ?? .equal,
      toItem: toView ?? superview!,
      attribute: toViewAttribute ?? attribute,
      multiplier: multiplier,
      constant: constant)
    constraint.priority = priority
    superview!.addConstraint(constraint)
    
    return constraint
  }
  
  @discardableResult
  func ql_set(
    size: CGSize,
    relation: NSLayoutConstraint.Relation? = nil,
    multiplier: CGFloat? = nil,
    priority: UILayoutPriority? = nil
    ) -> SizeConstraints {
    return SizeConstraints(
      width: ql_set(.width, relation: relation, multiplier: multiplier, constant: size.width, priority: priority),
      height: ql_set(.height, relation: relation, multiplier: multiplier, constant: size.height, priority: priority))
  }
  
  @discardableResult
  func ql_set(
    _ attribute: NSLayoutConstraint.Attribute,
    relation: NSLayoutConstraint.Relation? = nil,
    multiplier: CGFloat? = nil,
    constant: CGFloat? = nil,
    priority: UILayoutPriority? = nil
    ) -> NSLayoutConstraint {
    translatesAutoresizingMaskIntoConstraints = false
    
    let constraint = NSLayoutConstraint(
      item: self,
      attribute: attribute,
      relatedBy: relation ?? .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: multiplier ?? 1.0,
      constant: constant ?? 0.0)
    constraint.priority = priority ?? UILayoutPriority.required
    superview!.addConstraint(constraint)
    
    return constraint
  }
}

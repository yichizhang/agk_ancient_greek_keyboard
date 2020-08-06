//  Copyright (c) 2016-present Yichi. All rights reserved.

import Foundation
import Async

typealias TouchBeganClosure = ((_ beganViewID: String) -> Void)
typealias TouchThrottleClosure = (() -> Void)
typealias TouchLongPressDetectedClosure = ((_ viewID: String) -> Void)
typealias TouchViewIDChangeClosure = ((_ lastViewID: String?, _ currentViewID: String?) -> Void)
typealias TouchPhaseChangeClosure = ((_ touchData: DetailedTouchData) -> Void)

struct DetailedTouchData {
  let touchPoint: CGPoint!

  let beganViewID: String!
  let currentViewID: String?
  let lastViewID: String?
}

struct ThrottleData {
  
  var triggerInterval: TimeInterval
  var interval: TimeInterval
  var action: TouchThrottleClosure
}

protocol TouchHandlerDelegate: class {
  func touchHandler(_ touchHandler: TouchHandler, viewIDForPoint point: CGPoint) -> String?
  func touchHandlerDidFinish(_ touchHandler: TouchHandler)
}

class TouchHandler: NSObject {
  private(set) var delegate: TouchHandlerDelegate?

  private(set) var touch: UITouch?
  var touchPoint: CGPoint {
    if let touch = touch, let view = touch.view {
      return touch.location(in: view)
    }
    return CGPoint.zero
  }

  private(set) var beganViewID: String!
  private(set) var _currentViewID: String?

  private var onThrottle: ThrottleData?
  private var onLongPressDetected: TouchLongPressDetectedClosure?
  private var onMove: TouchPhaseChangeClosure?
  private var onViewIDChange: TouchViewIDChangeClosure?
  private var onEnd: TouchPhaseChangeClosure? // Includes 'cancel'

  init?(
    delegate: TouchHandlerDelegate,
    touch: UITouch,
    onBegan: TouchBeganClosure? = nil,
    onThrottle: ThrottleData? = nil,
    onLongPressDetected: TouchLongPressDetectedClosure? = nil,
    onMove: TouchPhaseChangeClosure? = nil,
    onViewIDChange: TouchViewIDChangeClosure? = nil,
    onEnd: TouchPhaseChangeClosure? = nil) {
    super.init()

    self.delegate = delegate
    self.touch = touch

    if let beganViewID = delegate.touchHandler(self, viewIDForPoint: touchPoint) {
      self.beganViewID = beganViewID
    } else {
      return nil
    }

    onBegan?(beganViewID)
    
    self.onThrottle = onThrottle
    self.onLongPressDetected = onLongPressDetected
    self.onMove = onMove
    self.onViewIDChange = onViewIDChange
    self.onEnd = onEnd

    update(currentViewID: beganViewID)

    throttle()
  }

  deinit {
    self.cancelLongPressTimer()
  }

  private func cleanUp() {
    cancelLongPressTimer()
    
    onEnd?(createTouchData())
    
    onThrottle = nil
    onLongPressDetected = nil
    onMove = nil
    onViewIDChange = nil
    onEnd = nil

    delegate?.touchHandlerDidFinish(self)

    delegate = nil
    touch = nil
    _currentViewID = nil
  }

  func touchMoved() {
    let touchData = createTouchData()
    update(currentViewID: touchData.currentViewID)

    onMove?(touchData)
  }

  func touchEnded() {
    touchEndedOrCancelled()
  }

  func touchCancelled() {
    touchEndedOrCancelled()
  }

  private var ended = false
  private func touchEndedOrCancelled() {
    if ended {
      return
    }
    ended = true
    
    let touchData = createTouchData()
    update(currentViewID: touchData.currentViewID)

    cleanUp()
  }

  private func createTouchData() -> DetailedTouchData {
    let viewID = delegate?.touchHandler(self, viewIDForPoint: touchPoint)

    return DetailedTouchData(
      touchPoint: touchPoint,
      beganViewID: beganViewID,
      currentViewID: viewID,
      lastViewID: _currentViewID)
  }

  private func update(currentViewID: String?) {
    if _currentViewID != currentViewID {
      onViewIDChange?(
        _currentViewID,
        currentViewID)

      cancelLongPressTimer()
      if onLongPressDetected != nil {
        scheduleLongPressTimer()
      }

      _currentViewID = currentViewID
    }
  }

  // MARK: Long press related
  private let longPressInterval: TimeInterval = 0.5
  private(set) var longPressTimer: Timer?
  private(set) var isLongPressDetected: Bool = false

  private func scheduleLongPressTimer() {
    longPressTimer?.invalidate()

    longPressTimer = Timer.scheduledTimer(
      timeInterval: longPressInterval,
      target: self,
      selector: #selector(longPressDetected(_:)),
      userInfo: nil,
      repeats: false)
  }

  private func cancelLongPressTimer() {
    longPressTimer?.invalidate()
    longPressTimer = nil
  }

  @objc private func longPressDetected(_: Timer) {
    cancelLongPressTimer()

    isLongPressDetected = true

    if let viewID = self.delegate?.touchHandler(self, viewIDForPoint: touchPoint) {
      onLongPressDetected?(viewID)
    }
  }

  // MARK: Throttle related
  private var throttleCount = 0
  @objc private func throttle() {
    guard let onThrottle = self.onThrottle else {
      return
    }

    let interval = (throttleCount == 0) ? onThrottle.triggerInterval : onThrottle.interval
    Async.main(after: interval) {
      if let onThrottle = self.onThrottle {
        onThrottle.action()

        self.throttleCount += 1
        self.throttle()
      }
      else {
        self.throttleCount = 0
      }
    }
  }
}

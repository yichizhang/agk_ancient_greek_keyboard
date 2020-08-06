//
//  Created by Yichi Zhang on 2017-10-27.
//  Copyright (c) 2017-present yichizhang. All rights reserved.
//

import XCTest

class AGKUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    let app = XCUIApplication()
    //setupSnapshot(app)
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    app.launchArguments = ["AGKUITests"]
    app.launch()
    
    sleep(2)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testKeyboardScreen() {
    let app = XCUIApplication()
    
    snapshot("02_home")
    
    app.staticTexts["Test the keyboard"].tap()
    
    let textView = app.textViews.element(boundBy: 0)
    waitForElementToAppear(textView)
    textView.tap()
    
    snapshot("00_kbMainUI")
    
    let extraSymbols = app.buttons["SYSTEM KEY - MORE SYMBOLS"]
    waitForElementToAppear(extraSymbols)
    extraSymbols.tap()
    
    snapshot("01_kbUIExtraSymbols")
  }
  
  func testSettingsScreen() {
    let app = XCUIApplication()
    
    sleep(1)
    
    app.staticTexts["Settings"].tap()
    
    snapshot("03_settings_home")
    
    sleep(1)
    
    app.staticTexts["Font"].tap()
    
    snapshot("04_settings_font_config")
  }
}

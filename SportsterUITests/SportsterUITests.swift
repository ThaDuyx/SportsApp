//
//  SportsterUITests.swift
//  SportsterUITests
//
//  Created by Simon Andersen on 29/09/2020.
//

import XCTest

class SportsterUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testLoginErrors() {
        let invalidEmail = "TestTest.com"
        let invalidPass = "testtestt"
        let validEmail = "test@test.com"
        let validPass = "testtest"
        var loginTest = 0
        
        let app = XCUIApplication()
        app.launch()
        
        while loginTest <= 1 {
            if loginTest == 0 {
                let app = XCUIApplication()
                app.staticTexts["Forsæt med E-mail"].tap()
                let email = app.textFields["Email"]
                let pass = app.secureTextFields["Kodeord"]
                
                //Wrong email but correct password
                email.tap()
                email.typeText(invalidEmail)
                pass.tap()
                pass.typeText(validPass)
                app.buttons["Log ind"].tap()
                
                //Correct email but wrong password
                email.tap()
                email.buttons["Clear text"].tap()
                email.typeText(validEmail)
                pass.tap()
                pass.buttons["Clear text"].tap()
                pass.typeText(invalidPass)
                app.buttons["Log ind"].tap()
                
                loginTest += 1
            } else {
                let email = app.textFields["Email"]
                let pass = app.secureTextFields["Kodeord"]

                email.tap()
                email.buttons["Clear text"].tap()
                email.typeText(validEmail)
                pass.tap()
                pass.buttons["Clear text"].tap()
                pass.typeText(validPass)
                app.buttons["Log ind"].tap()
                
                loginTest += 1
            }
        }
    }
    
    func testValidLoginSuccess(){
        let validEmail = "test@test.com"
        let validPass = "testtest"
        var loginTest = 0
        
        let app = XCUIApplication()
        app.launch()
        
        while loginTest <= 1 {
            if loginTest == 0 {
                let app = XCUIApplication()
                app.staticTexts["Forsæt med E-mail"].tap()
                app.staticTexts["Log ind"].tap()
                app.alerts["Hov, du har vist glemt noget"].scrollViews.otherElements.buttons["Prøv igen"].tap()
                loginTest += 1
            } else {
                let userName = app.textFields["Email"]
                userName.tap()
                userName.typeText(validEmail)
                
                let passwordSecureTextField = app.secureTextFields["Kodeord"]
                passwordSecureTextField.tap()
                passwordSecureTextField.typeText(validPass)
                
                app.buttons["Log ind"].tap()
                loginTest += 1
            }
        }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}

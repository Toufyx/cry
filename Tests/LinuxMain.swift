import XCTest

import cryTests

var tests = [XCTestCaseEntry]()
tests += cryTests.allTests()
XCTMain(tests)
import XCTest

import CodableSaveLoadTests

var tests = [XCTestCaseEntry]()
tests += CodableSaveLoadTests.allTests()
XCTMain(tests)

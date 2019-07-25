import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LoadTests.allTests),
        testCase(SaveTests.allTests),
        testCase(RemoveTests.allTests)
    ]
}
#endif

import XCTest
import CodableSaveLoad

class RemoveTests: BaseTests {
    
    func testRemoving() throws {
        //given
        let url  = getDocumentURL()
        let data = "{\"text\":\"This is test\"}".data(using: .utf8)!
        try data.write(to: url)
        let expectation = self.expectation(description: "Removing")
        
        //when
        Dummy.delete().done { _ in
            expectation.fulfill()
        }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.absoluteString))
        
    }
    
    func testRemovingFromURL() throws {
        //given
        let url  = getDocumentURL()
        let data = "{\"text\":\"This is test\"}".data(using: .utf8)!
        try data.write(to: url)
        let expectation = self.expectation(description: "Removing")
        
        //when
        Dummy.delete(url: url).done { _ in
            expectation.fulfill()
        }.catch { error in
            XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.absoluteString))
        
    }
    
    func testRemovingFromCache() throws {
        //given
        let url  = getDocumentURL(.cachesDirectory)
        let data = "{\"text\":\"This is test\"}".data(using: .utf8)!
        try data.write(to: url)
        let expectation = self.expectation(description: "Removing")
        
        //when
        Dummy.deleteFromCache().done { _ in
            expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.absoluteString))
        
    }
    
    func testDeleteInEmptyPathList() throws {
        //given
        let expectation = self.expectation(description: "Saving")
        
        //when
        Dummy.delete(directory: .userDirectory).done { _ in
            XCTFail("should not happend")
            expectation.fulfill()
        }.catch { error in
            defer {
                expectation.fulfill()
            }
            guard case Errors.noDirectory = error else {
                XCTFail("error is \(error)")
                return
            }
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTryToRemoveWebsite() throws {
        //given
        let expectation = self.expectation(description: "Removing")
        
        //when
        Dummy.delete(url: URL(string: "http://test.io/test")!).done { _ in
            XCTFail("should not happend")
            expectation.fulfill()
        }.catch { error in
            guard case Errors.notFileURL = error else {
                XCTFail("error is \(error)")
                return
            }
            expectation.fulfill()
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }

    static var allTests = [
        ("testRemoving", testRemoving),
        ("testRemovingFromURL", testRemovingFromURL),
        ("testRemovingFromCache", testRemovingFromCache),
        ("testDeleteInEmptyPathList", testDeleteInEmptyPathList),
        ("testTryToRemoveWebsite", testTryToRemoveWebsite)
    ]
}


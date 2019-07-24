import XCTest
import CodableSaveLoad

class SaveTests: BaseTests {

    func testSaving() throws {
        //given
        let dummy = Dummy(text: "This is test")
        let expectation = self.expectation(description: "Saving")
        
        //when
        dummy.save().done { _ in
            expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        
        let savedURL = getDocumentURL()
        let data = try Data(contentsOf: savedURL)
        let text = String(data: data, encoding: .utf8)!
        XCTAssertEqual(text, "{\"text\":\"This is test\"}")
    }
    
    
    func testSavingURL() throws {
        //given
        let dummy = Dummy(text: "This is test")
        let url = getDocumentURL()
        let expectation = self.expectation(description: "Saving")
        
        //when
        dummy.save(url: url).done { _ in
            expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        
        let data = try Data(contentsOf: url)
        let text = String(data: data, encoding: .utf8)!
        XCTAssertEqual(text, "{\"text\":\"This is test\"}")
    }
    
    func testSavingInCache() throws {
        //given
        let dummy = Dummy(text: "This is test")
        let url = getDocumentURL(.cachesDirectory)
        let expectation = self.expectation(description: "Saving")
        
        //when
        dummy.saveInCache().done { _ in
            expectation.fulfill()
        }.catch { error in
            XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        
        let data = try Data(contentsOf: url)
        let text = String(data: data, encoding: .utf8)!
        XCTAssertEqual(text, "{\"text\":\"This is test\"}")
    }
    
    func testSavingInEmptyPathList() throws {
        //given
        let dummy = Dummy(text: "This is test")
        let expectation = self.expectation(description: "Saving")
        
        //when
        dummy.save(directory: .userDirectory).done { _ in
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
    
    
    func testPerformanceOfSaving() {
        self.measure {
            //given
            let dummy = Dummy(text: "This is test")
            let expectation = self.expectation(description: "Saving")
            
            //when
            dummy.save().done { _ in
                expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
            }
            
            //then
            waitForExpectations(timeout: 5, handler: nil)
        }
    }
    
    static var allTests = [
        ("testSaving", testSaving),
        ("testSavingURL", testSavingURL),
        ("testSavingInCache", testSavingInCache),
        ("testSavingInEmptyPathList", testSavingInEmptyPathList),
        ("testPerformanceOfSaving", testPerformanceOfSaving)
    ]

}

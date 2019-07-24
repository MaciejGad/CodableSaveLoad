import XCTest
@testable import CodableSaveLoad

class CodableSaveLoadTests: XCTestCase {
    
    override func tearDown() {
        //remove test data
        try? FileManager.default.removeItem(at: getDocumentURL())
    }
    
    func testLoading() {
        //given
        let expectation = self.expectation(description: "reading")
        let bundle = Bundle(for: CodableSaveLoadTests.self)
        
        //when
        TestDummy
            .load(urlCreator: bundle.file(name:extention:))
            .done { dummy in
                XCTAssertEqual(dummy.text, "This is loaded from test bundle")
                expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSaving() throws {
        //given
        let dummy = TestDummy(text: "This is test")
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
    
    func testRemoving() throws {
        //given
        let data = "{\"text\":\"This is test\"}".data(using: .utf8)!
        try data.write(to: getDocumentURL())
        let expectation = self.expectation(description: "Removing")
        
        //when
        TestDummy.delete().done { _ in
            expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(FileManager.default.fileExists(atPath: getDocumentURL().absoluteString))
        
    }
    
    func testSaveToCache() throws {
        //given
        let dummy = TestDummy(text: "This is cache test")
        let expectation = self.expectation(description: "Saving")
        
        //when
        dummy.save(urlCreator: cacheUrl(name:extention:)).done { _ in
            expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
        let savedURL = getDocumentURL(.cachesDirectory)
        let data = try Data(contentsOf: savedURL)
        let text = String(data: data, encoding: .utf8)!
        XCTAssertEqual(text, "{\"text\":\"This is cache test\"}")
    }
    
    func testTryToRemoveWebsite() throws {
        //given
        let expectation = self.expectation(description: "Removing")
        
        //when
        TestDummy.delete(urlCreator: website(name:extention:)).done { _ in
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
    
    func testBundleLoadNoFile() throws {
        //given
        let expectation = self.expectation(description: "reading")
        let bundle = Bundle(for: CodableSaveLoadTests.self)
        
        //when
        TestDummy
            .load(name: "OtherName", urlCreator: bundle.file(name:extention:))
            .done { dummy in
                XCTFail("should not happend")
                expectation.fulfill()
            }.catch { error in
                defer {
                    expectation.fulfill()
                }
                guard case Errors.noFile = error else {
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
            let dummy = TestDummy(text: "This is test")
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
    
    func testPerformanceOfRemoving() throws {
        self.measure {
            //given
            let data = "{\"text\":\"This is test\"}".data(using: .utf8)!
            try! data.write(to: getDocumentURL())
            let expectation = self.expectation(description: "Removing")
            
            //when
            TestDummy.delete().done { _ in
                expectation.fulfill()
                }.catch { error in
                    XCTFail("\(error)")
            }
            
            //then
            waitForExpectations(timeout: 5, handler: nil)
        }
    }
    
    func testPerformanceOfLoading() {
        self.measure {
            self.testLoading()
        }
    }
    
    func testEmptyPathList() {
        XCTAssertThrowsError(try userDirectory(.userDirectory, name: "Test", extention: "txt"))
    }
    
//    func testAllUserDirectories() {
//        let allSearchPathDirectories: [FileManager.SearchPathDirectory] = [.applicationDirectory, .demoApplicationDirectory, .developerApplicationDirectory, .adminApplicationDirectory, .libraryDirectory, .developerDirectory, .userDirectory, .documentationDirectory, .documentDirectory, .coreServiceDirectory, .autosavedInformationDirectory, .desktopDirectory, .cachesDirectory, .applicationSupportDirectory, .downloadsDirectory, .inputMethodsDirectory, .moviesDirectory, .musicDirectory, .picturesDirectory, .printerDescriptionDirectory, .sharedPublicDirectory, .preferencePanesDirectory, .itemReplacementDirectory, .allApplicationsDirectory, .allLibrariesDirectory
//        ]
//
//        for searchPath in allSearchPathDirectories {
//            do {
//                _ = try userDirectory(searchPath, name: "Test", extention: "txt")
//            } catch {
//                print("\(searchPath) - \(error)")
//            }
//        }
//
//    }
}

extension CodableSaveLoadTests {
    private func getDocumentURL(_ directory: FileManager.SearchPathDirectory = .documentDirectory) -> URL {
        let list = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
        var url = URL(fileURLWithPath: list.first!, isDirectory: true)
        url.appendPathComponent("TestDummy", isDirectory: false)
        url.appendPathExtension("json")
        return url
    }
}

func website(name: String,  extention: String) throws -> URL {
    return URL(string: "http://test.io/test")!
}

struct TestDummy: Codable {
    let text: String
}

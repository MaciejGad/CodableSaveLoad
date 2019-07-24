import XCTest
import CodableSaveLoad

class LoadTests: BaseTests {
    
    func testLoadingFromURL() {
        //given
        let expectation = self.expectation(description: "reading")
        let url = Bundle(for: LoadTests.self).url(forResource: "Dummy", withExtension: "json")!
        
        //when
        Dummy.load(url: url).done { dummy in
            XCTAssertEqual(dummy.text, "This is loaded from test bundle")
            expectation.fulfill()
        }.catch { error in
            XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadingFromBundle() {
        //given
        let expectation = self.expectation(description: "reading")
        let bundle = Bundle(for: LoadTests.self)
        
        //when
        Dummy.load(bundle: bundle).done { dummy in
            XCTAssertEqual(dummy.text, "This is loaded from test bundle")
            expectation.fulfill()
        }.catch { error in
            XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadingFromDocument() throws {
        //given
        let givenMessage = "This is test"
        let data = "{\"text\":\"\(givenMessage)\"}".data(using: .utf8)!
        try data.write(to: getDocumentURL())
        
        //given
        let expectation = self.expectation(description: "reading")

        //when
        Dummy.load().done { dummy in
            XCTAssertEqual(dummy.text, givenMessage)
            expectation.fulfill()
        }.catch { error in
            XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadingFromCache() throws {
        //given
        let givenMessage = "This is test"
        let data = "{\"text\":\"\(givenMessage)\"}".data(using: .utf8)!
        try data.write(to: getDocumentURL(.cachesDirectory))
        
        //given
        let expectation = self.expectation(description: "reading")

        //when
        Dummy.loadFromCache().done { dummy in
            XCTAssertEqual(dummy.text, givenMessage)
            expectation.fulfill()
            }.catch { error in
                XCTFail("\(error)")
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    

    
    func testBundleLoadNoFile() throws {
        //given
        let expectation = self.expectation(description: "reading")
        let bundle = Bundle(for: LoadTests.self)
        
        //when
        Dummy
            .load(bundle: bundle, name: "OtherName")
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

    func testPerformanceOfLoading() {
        self.measure {
            self.testLoadingFromBundle()
        }
    }
    
    func testEmptyPathList() throws {        
        //given
        let expectation = self.expectation(description: "reading")
        
        //when
        Dummy.load(directory: .userDirectory)
            .done { dummy in
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

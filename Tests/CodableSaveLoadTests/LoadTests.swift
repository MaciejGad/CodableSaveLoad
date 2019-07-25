import XCTest
import CodableSaveLoad

class LoadTests: BaseTests {
    
    #if BUNDLE_TEST
    func testLoadingFromURL() {
        //given
        let expectation = self.expectation(description: "reading")
        guard let url = Bundle(for: LoadTests.self).url(forResource: "Dummy", withExtension: "json") else {
            XCTFail("Can't run testLoadingFromURL - not bundle url")
            expectation.fulfill()
            return
        }
        
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
    #endif

     #if BUNDLE_TEST
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
            expectation.fulfill()
        }
        
        //then
        waitForExpectations(timeout: 5, handler: nil)
    }
    #endif
    
    func testLoadingFromDocument() throws {
        //before
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

    func testPerformanceOfLoading() throws {
        let givenMessage = "This is test"
        let data = "{\"text\":\"\(givenMessage)\"}".data(using: .utf8)!
        try data.write(to: getDocumentURL())

        self.measure {
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

        static var allTests = [
            ("testLoadingFromDocument", testLoadingFromDocument),
            ("testLoadingFromCache", testLoadingFromCache),
            ("testBundleLoadNoFile", testBundleLoadNoFile),
            ("testPerformanceOfLoading", testPerformanceOfLoading),
            ("testEmptyPathList", testEmptyPathList)
        ]
}

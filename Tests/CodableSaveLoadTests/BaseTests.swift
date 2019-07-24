//
//  BaseTests.swift
//  CodableSaveLoadTests
//
//  Created by Maciej Gad on 24/07/2019.
//  Copyright © 2019 MaciejGad. All rights reserved.
//

import XCTest

class BaseTests: XCTestCase {

    override func setUp() {
        try? FileManager.default.removeItem(at: getDocumentURL())
        try? FileManager.default.removeItem(at: getDocumentURL(.cachesDirectory))
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: getDocumentURL())
        try? FileManager.default.removeItem(at: getDocumentURL(.cachesDirectory))
    }

    func getDocumentURL(_ directory: FileManager.SearchPathDirectory = .documentDirectory) -> URL {
            let list = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
            var url = URL(fileURLWithPath: list.first!, isDirectory: true)
            url.appendPathComponent("Dummy", isDirectory: false)
            url.appendPathExtension("json")
            return url
    }

}

//
//  PixabayModelTest.swift
//  CandySpace PixabayTests
//
//  Created by Andreas Velounias on 27/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import XCTest
@testable import CandySpace_Pixabay

class PixabayModelTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAuthorName() {
        let model = Pixabay(authorName: "John Smith", imageURL: "")
        XCTAssertEqual(model.authorName == "John Smith" , true)
    }
    
    func testImageURL() {
        let model = Pixabay(authorName: "", imageURL: "https://pixabay.com/get/54e6dc464f54a514f1dc8460c62b3677123fdde64e507441702d7ddd914dc0_640.jpg")
        XCTAssertEqual(model.imageURL == "https://pixabay.com/get/54e6dc464f54a514f1dc8460c62b3677123fdde64e507441702d7ddd914dc0_640.jpg" , true)
    }
 
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

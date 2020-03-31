//
//  PixabayAPITest.swift
//  CandySpace PixabayTests
//
//  Created by Andreas Velounias on 27/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import XCTest
@testable import CandySpace_Pixabay

class PixabayAPITest: XCTestCase {

    var viewModel = PixabayViewModel(httpClient: HttpClient(with: URLSession.shared))
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageDownload() {
        // This is more of an integration test. It can be performed as a unit test using mock data
        viewModel.downloadImage(with: "https://pixabay.com/get/54e6dc464f54a514f1dc8460c62b3677123fdde64e507441702d7ddd914dc0_640.jpg") { (error, image) in
            if (error != nil) {
                XCTFail("Failed to download image")
            } else {
                XCTAssert(image != nil, "Image has been downloaded")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

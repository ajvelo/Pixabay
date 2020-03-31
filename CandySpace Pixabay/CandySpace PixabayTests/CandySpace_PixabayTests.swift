//
//  CandySpace_PixabayTests.swift
//  CandySpace PixabayTests
//
//  Created by Andreas Velounias on 26/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import XCTest
@testable import CandySpace_Pixabay

class CandySpace_PixabayTests: XCTestCase {
    
    let viewModel = PixabayViewModel(httpClient: HttpClient(with: URLSession.shared))

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        viewModel.searchImages(with: "space") { (result) in
                    print(result)
        //            XCTAssert(result == , "API called with space as query")
                }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

//
//  PixabayViewModelTest.swift
//  CandySpace PixabayTests
//
//  Created by Andreas Velounias on 27/03/2020.
//  Copyright © 2020 Andreas Velounias. All rights reserved.
//

import XCTest
@testable import CandySpace_Pixabay

class PixabayViewModelTest: XCTestCase {

    var viewModel = PixabayViewModel(httpClient: HttpClient(with: URLSession.shared))
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelSave() {
        // This is an example of a functional test case.
        viewModel.savePixabayItem(item: Pixabay(authorName: "John Smith", imageURL: "https://spaceplace.nasa.gov/templates/featured/space/galaxies300.png"))
        XCTAssert(viewModel.pixabayItems.count == 1, "View model has 1 item")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

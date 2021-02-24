//
//  List_StargazersTests.swift
//  List StargazersTests
//
//  Created by Mattia Cardone on 22/02/2021.
//  Copyright © 2021 Mattia Cardone. All rights reserved.
//

import XCTest
@testable import List_Stargazers

class List_StargazersTests: XCTestCase {

    func testDecodeResponse() {
        guard let data = "[{\"login\":\"mattia-ui\",\"avatar_url\":\"https://avatars.githubusercontent.com/u/58041010?s=60&v=4\"}]".jsonify else {
            XCTFail()
            return
        }
        let result = GitHub.decode(data, error: nil)

        switch result {
        case .failure(_):
            XCTFail("Success expected")
        case .success(let stargazer):
            XCTAssertNotNil(stargazer)
            XCTAssertEqual(1, stargazer.count)
            XCTAssertEqual("https://avatars.githubusercontent.com/u/58041010?s=60&v=4", stargazer.first?.avatar)
            XCTAssertEqual("mattia-ui", stargazer.first?.username)
        }
    }

    func testDecodeResponseMissingKey() {
        guard let data = "[{\"login\":\"mattia-ui\"}]".jsonify else {
            XCTFail()
            return
        }
        let result = GitHub.decode(data, error: nil)

        switch result {
        case .failure(let error):
            XCTAssertNotNil(error)
        case .success(_):
            XCTFail("Failure expected")
        }
    }

    func testDecodeWrongDataResponse() {
        let result = GitHub.decode(nil, error: nil)

        switch result {
        case .failure(let error):
            XCTAssertNotNil(error)
            XCTAssertEqual("No data fetched", error.localizedDescription)
        case .success(_):
            XCTFail("Failure expected")
        }
    }

    func testDecodeResponseError() {
        let result = GitHub.decode(Data(), error: MyError.mocked)
        
        switch result {
        case .failure(let error):
            XCTAssertNotNil(error)
            XCTAssertEqual("An error has occurred", error.localizedDescription)
        case .success(_):
            XCTFail("Failure expected")
        }
    }
}

private enum MyError: Error {
    case mocked
}

private extension String {
    var jsonify: Data? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
         return data
    }
}

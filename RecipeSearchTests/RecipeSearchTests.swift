//
//  RecipeSearchTests.swift
//  RecipeSearchTests
//
//  Created by Brendon Crowe on 1/17/23.
//

import XCTest
@testable import RecipeSearch

class RecipeSearchAPITests: XCTestCase {
    
    
    
    func testSearchChristmasCookies() {
        // arrange
        // convert string to a url friendly string
        let searchQuery = "christmas cookies".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let exp = XCTestExpectation(description: "searches found")
        let recipeEndpointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKey.appId)&app_key=\(SecretKey.appKey)&from=0&to=50"
        
        let request = URLRequest(url: URL(string: recipeEndpointURL)!)
        
        // act
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("appError: \(appError)")
            case .success(let data):
                // must use in order to run assert
                exp.fulfill()
                // assert
                XCTAssertGreaterThan(data.count, 800000, "data should be greater than \(data.count)")
            }
        }
        wait(for: [exp], timeout: 5.0)
    }
}

//
//  ApiRepositoryTest.swift
//  JakeGithubRepositoriesTests
//
//  Created by Alaa Taher on 9/3/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import XCTest
@testable import JakeGithubRepositories

class ApiRepositoryTest: XCTestCase {

    typealias responseHandler = (Result<Repository, ApiError>)->Void
    var jsonData = "[{\"name\": \"abs.io\",\"html_url\": \"https://github.com/JakeWharton/abs.io\"}]".data(using: .utf8)
    
    let httpResponse = HTTPURLResponse(url: URL(string: "https://api.github.com/users/JakeWharton/repos?page=1&per_page=1")!, statusCode: 200, httpVersion: nil, headerFields: nil)
   
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testGetRepositoryWithExpectedURLHostAndPath() {
        let mockUrlSession = MockURLSession(data: nil,urlResponse: nil,err: nil)
        let param :[String:String] = ["page":"\(1)","per_page":"\(1)"]
        let apiClent:ApiClientProtocol = ApiClient(params: param, apiPath: .repos,urlSession:mockUrlSession)
        callingApi(apiClient: apiClent) { (result) in
            
        }
        XCTAssertEqual(mockUrlSession.cachedUrl?.host, "api.github.com")
        XCTAssertEqual(mockUrlSession.cachedUrl?.path, "/users/JakeWharton/repos")
        
    }
    func testGetTagsSuccessReturnsRepositories() {
        
        let mockUrlSession = MockURLSession(data: jsonData,urlResponse: httpResponse,err: nil)
        let param :[String:String] = ["page":"\(1)","per_page":"\(1)"]

        let apiClent:ApiClientProtocol = ApiClient(params: param, apiPath: .repos,urlSession:mockUrlSession)

        var repositories:[Repository]?
        let tagsExpectation = expectation(description: "repositories")
        callingApi(apiClient: apiClent) { (result) in
            switch result{
            case .success(let model):
                repositories = model
                tagsExpectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 10) { (err) in
            XCTAssertNotNil(repositories)
        }
        
    }
    func testGetRepositoriesWhenResponseErrorReturnsError() {
        
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockUrlSession = MockURLSession(data: nil,urlResponse: nil,err: error)
        let param :[String:String] = ["page":"\(1)","per_page":"\(1)"]
        
        let apiClent:ApiClientProtocol = ApiClient(params: param, apiPath: .repos,urlSession:mockUrlSession)

        let errorExpectation = expectation(description: "error")
        var errorResponse: ApiError?
        callingApi(apiClient: apiClent) { (result) in
            switch result{
            case .failure(let err):
                errorResponse = err
                errorExpectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }
    func testGetRepositoriesInvalidJSONReturnsError() {
        jsonData = "[{\"t\"}]".data(using: .utf8)
        
        let mockUrlSession = MockURLSession(data: jsonData,urlResponse: httpResponse,err: nil)
        
        let param :[String:String] = ["page":"\(1)","per_page":"\(1)"]
        
        let apiClent:ApiClientProtocol = ApiClient(params: param, apiPath: .repos,urlSession:mockUrlSession)
        let errorExpectation = expectation(description: "error")
        var errorResponse: ApiError?
        callingApi(apiClient: apiClent) { (result) in
            switch result{
            case .failure(let err):
                errorResponse = err
                errorExpectation.fulfill()
            default:
                break
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(errorResponse)
        }
    }

    func callingApi(apiClient:ApiClientProtocol,completion:@escaping responseHandler)  {
        apiClient.genericFetch { (result) in
            completion(result)
        }
        
    }
}

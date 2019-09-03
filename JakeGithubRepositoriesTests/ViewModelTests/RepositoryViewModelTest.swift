//
//  RepositoryViewModelTest.swift
//  JakeGithubRepositoriesTests
//
//  Created by Alaa Taher on 9/3/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import XCTest
import RealmSwift
@testable import JakeGithubRepositories

class RepositoryViewModelTest: XCTestCase {
    var repositoryViewModel:RepositoryViewModel?
    var repositoryService:MockRepositoryServices?
    var jsonData = "[{\"name\": \"abs.io\",\"html_url\": \"https://github.com/JakeWharton/abs.io\"}]".data(using: .utf8)
    
    let httpResponse = HTTPURLResponse(url: URL(string: "https://api.github.com/users/JakeWharton/repos?page=1&per_page=1")!, statusCode: 200, httpVersion: nil, headerFields: nil)

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "Test_DB"
        DBManger.sharedInstance.setRealm()
        repositoryService = MockRepositoryServices()
    }

    override func tearDown() {
        try! DBManger.sharedInstance.realm.write {
            DBManger.sharedInstance.realm.deleteAll()
        }
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
    func testFetchrepositoryWithSuccess() {
        let mockUrlSession = MockURLSession(data: jsonData,urlResponse: httpResponse,err: nil)
        repositoryService?.mockUrlSession = mockUrlSession
        repositoryViewModel = RepositoryViewModel(repositoryService!)
        repositoryViewModel?.fetechRepository()
        repositoryViewModel?.finishFetchWithSuccess = {[weak self]() in
            XCTAssertEqual(self?.repositoryViewModel?.getRepositoryCount(), 1)
        }
    }
    func testCachedRepositoryAfterSuccess() {
        
        let mockUrlSession = MockURLSession(data: jsonData,urlResponse: httpResponse,err: nil)
        repositoryService?.mockUrlSession = mockUrlSession
        repositoryViewModel = RepositoryViewModel(repositoryService!)
        repositoryViewModel?.fetechRepository()
        repositoryViewModel?.finishFetchWithSuccess = {() in
            XCTAssertEqual(DBManger.sharedInstance.getRepositoriesBy(pageNum: 1).count, 1)
        }
    }
    func testFetchDataWithError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockUrlSession = MockURLSession(data: nil,urlResponse: nil,err: error)
        repositoryService?.mockUrlSession = mockUrlSession
        repositoryViewModel = RepositoryViewModel(repositoryService!)
        repositoryViewModel?.fetechRepository()
        repositoryViewModel?.finishFetchWithError = {(err) in
            XCTAssertNotNil(err)
        }
    }
    func testOfflineData() {
        var repository = Repository(repositoryEntity: nil)
        repository.name = "test"
        repository.descriptionField = "test test"
        DBManger.sharedInstance.saveRepository(repository: RepositoryEntity(repository: repository, pageNum: 1))
        repositoryService!.offline = true
        repositoryViewModel?.fetechRepository()
        repositoryViewModel?.finishFetchWithSuccess = {[weak self]() in
            XCTAssertEqual(self?.repositoryViewModel?.getRepositoryAtIndex(index: 0)?.name, "test")
        }
        
        
    }
}

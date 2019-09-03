//
//  RepositoriesDBTests.swift
//  JakeGithubRepositoriesTests
//
//  Created by Alaa Taher on 9/3/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import XCTest
import Realm
import RealmSwift
@testable import JakeGithubRepositories
@testable import Pods_JakeGithubRepositories
class RepositoriesDBTests: XCTestCase {
    var repository = Repository(repositoryEntity: nil)

    override func setUp() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "Test_DB"
        DBManger.sharedInstance.setRealm()

        repository.name = "test"
        repository.fullName = "test test"
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
    func testAddRepository()  {
        DBManger.sharedInstance.saveRepository(repository: RepositoryEntity(repository: repository, pageNum: 1))
        XCTAssertEqual(DBManger.sharedInstance.getRepositoriesBy(pageNum: 1).count,1 )
    }
    func testFetchRepository()  {
        DBManger.sharedInstance.saveRepository(repository: RepositoryEntity(repository: repository, pageNum: 1))
        let repositoryEntity = DBManger.sharedInstance.getRepositoriesBy(pageNum: 1)
        let repository = Repository(repositoryEntity: repositoryEntity[0])
        XCTAssertEqual(repository.name,"test")
    }
    func testEmptyRepository()
    {
        let tagEntity = DBManger.sharedInstance.getRepositoriesBy(pageNum: 1)
        XCTAssertEqual(tagEntity.count,0)
    }
}

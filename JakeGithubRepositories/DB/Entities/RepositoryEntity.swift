
//
//  RepositoryEntity.swift
//  JakeGithubRepositories
//
//  Created by Alaa Taher on 9/3/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import UIKit
import RealmSwift

class RepositoryEntity:Object {
    @objc dynamic var descriptionField  = ""
    @objc dynamic var fullName = ""
    @objc dynamic var htmlUrl = ""
    @objc dynamic var id  = 0
    @objc dynamic var language = ""
    @objc dynamic var name = ""
    @objc dynamic var updatedAt = ""
    @objc dynamic var dateTimeAgo = ""
    @objc dynamic var pageNum = 0
    override static func primaryKey() -> String
    {
        return "id"
    }
}
extension RepositoryEntity{
    convenience init(repository:Repository,pageNum:Int) {
        self.init()
        self.descriptionField = repository.descriptionField ?? ""
        self.fullName = repository.fullName ?? ""
        self.htmlUrl = repository.htmlUrl ?? ""
        self.id = repository.id ?? 0
        self.name = repository.name ?? ""
        self.updatedAt = repository.updatedAt ?? ""
        self.dateTimeAgo = repository.dateTimeAgo ?? ""
        self.pageNum = pageNum
    }

}

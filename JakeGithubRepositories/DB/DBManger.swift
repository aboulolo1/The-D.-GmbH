//
//  TgesMangesDB.swift
//  Elmenus
//
//  Created by New  on 7/6/19.
//  Copyright © 2019 Elmenus. All rights reserved.
//

import UIKit
import RealmSwift

class DBManger {
    
    static let sharedInstance = DBManger()
    var realm : Realm!
    
    private init() {
    }
    
    func setRealm(realm:Realm = try! Realm())
    {
        self.realm = realm
    }
     func saveRepository(repository:RepositoryEntity)
    {
        
        try! realm.write {
            realm.add(repository, update: .all)
        }
    }
     func getRepositoriesBy(pageNum:Int)->[RepositoryEntity]
    {

        let repositoryDB = realm.objects(RepositoryEntity.self).filter("pageNum = \(pageNum)")
        var trepositoryEntityList : [RepositoryEntity] = []
        repositoryDB.forEach { (obj) in
            trepositoryEntityList.append(obj)
        }
        return trepositoryEntityList
    }
    
}

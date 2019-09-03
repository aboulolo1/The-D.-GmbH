//
//  RepositoryService.swift
//  JakeGithubRepositories
//
//  Created by Alaa Taher on 9/1/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import UIKit
protocol RepositoryProtocol {
    typealias responseHandler = (Result<Repository, ApiError>)->Void

    var pageNum:Int { get set }
    func fetchRepostoryFromApi(_ completion:@escaping responseHandler)
    func fetchRepostoryFromLocal(_ completion:@escaping responseHandler)
    func checkConnectivity()->Bool
    func fetchRepostory(_ completion:@escaping responseHandler)
    
}

protocol RepositoryEntityProtocol {
     func saveRepositoryEntity(repositoryList:[Repository])
    func getRepositoryEntity()->[Repository]
}
class RepositoryService: RepositoryProtocol,RepositoryEntityProtocol {
    var pageNum: Int = 0
    
    private var perPage = 15
    func checkConnectivity() -> Bool {
        if Connectivity.isConnectedToInternet {
            return true
        }
        return false
    }
    func fetchRepostory(_ completion:@escaping responseHandler)  {
        if checkConnectivity() {
            fetchRepostoryFromApi() { [weak self](result) in
                self?.savedRepositoryIntoLocal( result)
                completion(result)
            }
        }
        else
        {
            fetchRepostoryFromLocal { (result) in
                completion(result)
            }
        }
    }
    
    func fetchRepostoryFromLocal(_ completion: @escaping responseHandler) {
        if pageNum == 1{
            completion(.failure(ApiError.noConnetion))
        }
        let repositoryList = self.getRepositoryEntity()
        completion(.success(repositoryList))
    }
    
    
    func fetchRepostoryFromApi(_ completion: @escaping responseHandler) {
        let param :[String:String] = ["page":"\(pageNum)","per_page":"\(perPage)"]
        let apiClent:ApiClientProtocol = ApiClient(params: param, apiPath: .repos)
        apiClent.genericFetch { (result) in
            completion(result)
        }
    }
    
    private func savedRepositoryIntoLocal(_ result: Result<Repository, ApiError>){
        switch result {
        case .success(let response):
            self.saveRepositoryEntity(repositoryList: response)
            break
        default:break
        }

    }
    
    func saveRepositoryEntity(repositoryList:[Repository])
    {
        DBManger.sharedInstance.setRealm()
        repositoryList.forEach { (repository) in
            let repositoryEntity = RepositoryEntity(repository: repository, pageNum: pageNum)
            DBManger.sharedInstance.saveRepository(repository: repositoryEntity)
        }
    }
    func getRepositoryEntity()->[Repository]
    {
        var repositoryList:[Repository] = []
        DBManger.sharedInstance.setRealm()
        DBManger.sharedInstance.getRepositoriesBy(pageNum: pageNum).forEach { (repositoryEntity) in
            repositoryList.append(Repository(repositoryEntity: repositoryEntity))
        }
        return repositoryList
    }
}

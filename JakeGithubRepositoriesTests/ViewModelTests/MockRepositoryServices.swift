//
//  MockRepositoryServices.swift
//  JakeGithubRepositoriesTests
//
//  Created by Alaa Taher on 9/3/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import UIKit
@testable import JakeGithubRepositories

class MockRepositoryServices:RepositoryProtocol  {
    var pageNum: Int = 1
    var mockUrlSession:MockURLSession?
    var offline = false
    func fetchRepostoryFromApi(_ completion: @escaping MockRepositoryServices.responseHandler) {
        if !offline {
            let param :[String:String] = ["page":"\(pageNum)","per_page":"\(1)"]
            let apiClent:ApiClientProtocol = ApiClient(params: param, apiPath: .repos,urlSession:mockUrlSession!)
            
            apiClent.genericFetch { (results) in
                completion(results)
            }

        }
    }
    
    func fetchRepostoryFromLocal(_ completion: @escaping MockRepositoryServices.responseHandler) {
        
    }
    
    func checkConnectivity() -> Bool {
        return offline
    }
    
    func fetchRepostory(_ completion: @escaping MockRepositoryServices.responseHandler) {
        
    }
    

}

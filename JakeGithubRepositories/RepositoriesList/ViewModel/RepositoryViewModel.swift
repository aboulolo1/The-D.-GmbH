//
//  RepositoryViewModel.swift
//  JakeGithubRepositories
//
//  Created by Alaa Taher on 9/2/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import UIKit

class RepositoryViewModel {

    var updateLoadingStatus:((Bool)->Void)?
    var finishFetchWithError:((String)->Void)?
    var finishFetchWithSuccess:(()->Void)?
    var stopFetchingRepository:(()->Void)?

    private var repositoryService:RepositoryProtocol
    private var repositoryList:[Repository] = []

    init(_ repositoryService:RepositoryProtocol = RepositoryService()) {
        self.repositoryService = repositoryService
        self.repositoryService.pageNum = page
    }
    private var isLoading:Bool = false{
        didSet{
            self.updateLoadingStatus?(self.isLoading)
        }
    }
    
    var page:Int = 1{
        didSet{
            self.repositoryService.pageNum = page
        }
    }
    var removeInfiniteScroll:Bool = false
    func fetechRepository() {
        if page == 1{
            self.isLoading = true
        }
        self.repositoryService.fetchRepostory() {[weak self] (result) in
            self?.isLoading = false
            switch result{
            case .success(let repositoryArray):
                self?.ifRepositoryFound(repositoryArray)
            case .failure(let err):
                self?.finishFetchWithError?(err.localizedDescritpion)
            }
        }
    }
    private func ifRepositoryFound(_ repositoryList:[Repository])
    {
        if repositoryList.count == 0
        {
            removeInfiniteScroll = true
            stopFetchingRepository?()
        }
        else
        {
            self.page += 1
            self.repositoryList.append(contentsOf: repositoryList)
            self.finishFetchWithSuccess?()
        }
    }
    func getRepositoryCount() -> Int {
        return repositoryList.count
    }
    func getRepositoryAtIndex(index:Int) -> Repository? {
        if index < repositoryList.count{
            return repositoryList[index]
        }
        return nil
    }
}

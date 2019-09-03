//
//  RepositoryViewController.swift
//  JakeGithubRepositories
//
//  Created by Alaa Taher on 9/2/19.
//  Copyright © 2019 Alaa Taher. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftMessageBar

class RepositoryViewController: UIViewController {

    @IBOutlet weak var repositoryTB: UITableView!
    private var repositoryViewModel:RepositoryViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryViewModel = RepositoryViewModel()
        repositoryTB.estimatedRowHeight = 115
        repositoryTB.dataSource = self
        repositoryTB.delegate = self
        repositoryTB.tableFooterView = UIView()
        repositoryTB.addInfiniteScroll {(_) -> Void in}
        repositoryTB.infiniteScrollIndicatorStyle = .gray
       

    }
    override func viewWillAppear(_ animated: Bool) {
        updateLoading()
        fetchRepositorysucceeded()
        fetchRpositoryFaild()
        stopInfiniteScroll()
        self.repositoryViewModel?.fetechRepository()
    }
    private func stopInfiniteScroll()
    {
        repositoryViewModel?.stopFetchingRepository = { [weak self]()
            in
            DispatchQueue.main.async {
                self?.repositoryTB.removeInfiniteScroll()
            }
        }
    }
    private func updateLoading() {
        
        repositoryViewModel?.updateLoadingStatus = { (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    SVProgressHUD.show()
                }else {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    private func fetchRepositorysucceeded()
    {
        repositoryViewModel?.finishFetchWithSuccess = { [weak self]() in
            DispatchQueue.main.async {
                self?.repositoryTB.finishInfiniteScroll()
                self?.repositoryTB.reloadData()
            }
            
        }
    }
    private func fetchRpositoryFaild(){
        repositoryViewModel?.finishFetchWithError = { [weak self](message) in
            DispatchQueue.main.async {
                SwiftMessageBar.showMessage(withTitle: "Error", message: message, type: .error)
                self?.repositoryTB.finishInfiniteScroll()
            }
        }
    }

}
extension RepositoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositoryViewModel?.getRepositoryCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.repositoryTB.dequeueReusableCell(withIdentifier: "repositoryCell") as! RepositoryTableViewCell
        let repositoryModel = self.repositoryViewModel?.getRepositoryAtIndex(index: indexPath.row)
        cell.repositoryName.text = repositoryModel?.fullName
        cell.repositoryLanguage.text = "Language : " + (repositoryModel?.language ?? "")
        cell.repositoryDescription.text = repositoryModel?.descriptionField
        cell.repositoryDateUpdate.text = "updated " + (repositoryModel?.dateTimeAgo ?? "") + " ago"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (repositoryViewModel?.getRepositoryCount())!-3 && !repositoryViewModel!.removeInfiniteScroll{
            self.repositoryViewModel?.fetechRepository()
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryModel = self.repositoryViewModel?.getRepositoryAtIndex(index: indexPath.row)
        if let url = URL(string: (repositoryModel?.htmlUrl)!) {
            UIApplication.shared.open(url)
        }
    }
    
}

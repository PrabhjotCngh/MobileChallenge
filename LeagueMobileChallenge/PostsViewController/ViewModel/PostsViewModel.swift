//
//  PostsViewModel.swift
//  LeagueMobileChallenge
//
//  Created by Prabh on 2022-05-18.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit

class PostsViewModel: NSObject {
    //Private instances
    private var totalFailRequests = 0
    private var totalSuccessRequests = 0
    private let dispatchGroup = DispatchGroup()
    
    //Public instances
    var postsModel = [PostsModel]()
    var usersModel = [UsersModel]()
    var requestSucceeded: ()->() = {}
    var requestFailed: ()->() = {}
    
    //MARK: - Public methods
    func getUserToken() {
        APIController.shared.fetchUserToken { [weak self] token, error in
            if let _StrongSelf = self {
                _StrongSelf.getData()
            }
        }
    }
}

//MARK: - Private methods
extension PostsViewModel {
    private func getData() {
        getUsers()
        getPosts()
        dispatchGroup.notify(queue: .global()) { [weak self] in
            if let _StrongSelf = self {
                if _StrongSelf.totalFailRequests >= _StrongSelf.totalSuccessRequests {
                    _StrongSelf.requestFailed()
                } else {
                    _StrongSelf.requestSucceeded()
                }
            }
        }
    }
    
    private func getPosts() {
        guard let url = URL(string: APIController.shared.postAPI) else {
            return
        }
        dispatchGroup.enter()
        APIController.shared.request(url: url) {  [weak self] data, error in
            if let _StrongSelf = self {
                if let responseData = data {
                    do {
                        let decodedJson = try JSONDecoder().decode([PostsModel].self, from: responseData)
                        _StrongSelf.postsModel = decodedJson
                        _StrongSelf.totalSuccessRequests += 1
                    } catch {
                        _StrongSelf.totalFailRequests += 1
                    }
                } else if let _ = error {
                    _StrongSelf.totalFailRequests += 1
                }
                _StrongSelf.dispatchGroup.leave()
            }
        }
    }
    
    private func getUsers() {
        guard let url = URL(string: APIController.shared.userAPI) else {
            return
        }
        dispatchGroup.enter()
        APIController.shared.request(url: url) {  [weak self] data, error in
            if let _StrongSelf = self {
                if let responseData = data {
                    do {
                        let decodedJson = try JSONDecoder().decode([UsersModel].self, from: responseData)
                        _StrongSelf.usersModel = decodedJson
                        _StrongSelf.totalSuccessRequests += 1
                    } catch {
                        _StrongSelf.totalFailRequests += 1
                    }
                } else if let _ = error {
                    _StrongSelf.totalFailRequests += 1
                }
                _StrongSelf.dispatchGroup.leave()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PostsViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersModel.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell {
            if  postsModel.count >= indexPath.row && usersModel.count >= indexPath.row {
                let postsModel = postsModel[indexPath.row]
                let usersModel = usersModel[indexPath.row]
                cell.configureCell(postsModel, usersModel)
            }
            return cell
        }
        return UITableViewCell()
    }
}

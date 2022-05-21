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
    
    /// Fetch user token from API
    func getUserToken() {
        APIController.shared.fetchUserToken { [weak self] token, error in
            if let _StrongSelf = self {
                _StrongSelf.getData()
            }
        }
    }
    
    //MARK: - Tableview helper variables and methods
    
    /// Returns the number of rows in the dataSource
    var numberOfRows: Int {
        return usersModel.count > 0 && postsModel.count > 0 ? usersModel.count : 0
    }
    
    /// Returns the name for the given rowIndex
    func name(for rowIndex: Int) -> String? {
        let row = usersModel[rowIndex]
        return row.name
    }
    
    /// Returns the thumbnail url for the given rowIndex
    func thumbnail(for rowIndex: Int) -> String? {
        let row = usersModel[rowIndex]
        return row.avatar.thumbnail
    }
    
    /// Returns the name for the given rowIndex
    func title(for rowIndex: Int) -> String? {
        let row = postsModel[rowIndex]
        return row.title
    }
    
    /// Returns the body for the given rowIndex
    func body(for rowIndex: Int) -> String? {
        let row = postsModel[rowIndex]
        return row.body
    }
}

//MARK: - Private methods
extension PostsViewModel {
    /// Users and posts data  API request and update view
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
    
    /// Get all posts data
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
    
    /// Get all users data
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
    /// Tells the UITableView how many rows are needed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    /// Tells the UITableView max height for a row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Constructs and configures the item needed for the requested IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell {
            let rowIndex = indexPath.row
            if  postsModel.count >= rowIndex && usersModel.count >= rowIndex {
                cell.configureCell(name: name(for: rowIndex) ?? "", thumbnail: thumbnail(for: rowIndex) ?? "", title: title(for: rowIndex) ?? "", body: body(for: rowIndex) ?? "")
            }
            return cell
        }
        return UITableViewCell()
    }
}

//
//  PostsViewController.swift
//  LeagueMobileChallenge
//
//  Created by Prabh on 2022-05-18.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {
    //IBOutlets
    @IBOutlet weak var tvTableView: UITableView!
    
    //Private instances
    private let viewModel = PostsViewModel()
    
    //MARK: - View controller life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getUserToken()
        handleCallBacks()
        registerCell()
    }
}

// MARK: - UITableViewDataSource
extension PostsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersModel.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostsTableViewCell.identifier, for: indexPath) as? PostsTableViewCell {
            if  viewModel.postsModel.count >= indexPath.row && viewModel.usersModel.count >= indexPath.row {
                let postsModel = viewModel.postsModel[indexPath.row]
                let usersModel = viewModel.usersModel[indexPath.row]
                cell.configureCell(postsModel, usersModel)
            }
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - Private methods
extension PostsViewController {
    private func registerCell() {
        self.tvTableView.register(PostsTableViewCell.nib, forCellReuseIdentifier: PostsTableViewCell.identifier)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tvTableView.reloadData()
        }
    }
    
    private func handleCallBacks() {
        viewModel.requestSucceeded = { [weak self] in
            if let _StrongSelf = self {
                _StrongSelf.reloadTableView()
            }
        }
    
        viewModel.requestFailed = {
            DispatchQueue.main.async {
                Utility.displayAlert(title: AlertViewConstants.error, message: AlertViewConstants.errorMessage)
            }
        }
    }
}

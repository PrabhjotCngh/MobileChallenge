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
        intialiseTableView()
    }
}

//MARK: - Private methods
extension PostsViewController {
    /// Configure tableView with datasource and register tableViewCell
    private func intialiseTableView()  {
        tvTableView?.dataSource = viewModel
        tvTableView?.register(PostsTableViewCell.nib, forCellReuseIdentifier: PostsTableViewCell.identifier)
    }
    
    /// Reload tableView on main thread
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tvTableView.isHidden = false
            self.tvTableView.reloadData()
        }
    }
    
    /// Handle call backs from ViewModel
    private func handleCallBacks() {
        viewModel.requestSucceeded = { [weak self] in
            if let _StrongSelf = self {
                _StrongSelf.reloadTableView()
            }
        }
    
        viewModel.requestFailed = {
            DispatchQueue.main.async {
                self.tvTableView.isHidden = true
                Utility.displayAlert(title: AlertViewConstants.error, message: AlertViewConstants.errorMessage)
            }
        }
    }
}

//
//  UserSearchViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class UserSearchViewController: ModalViewController {

    private var users: [User] = []
    var presenter: UserSearchPresenter?
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Find Contacts".localized
        presenter = UserSearchPresenter()
        presenter?.attach(self)

        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.close()
    }

    private func showEmptyView(_ show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show {
                self.emptyView.alpha = 1.0
            } else {
                self.emptyView.alpha = 0.0
            }
            self.emptyView.isHidden = !show
        }
    }

}

extension UserSearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchCell", for: indexPath) as! UserSearchTableViewCell
        if let user = self.user(atIndex: indexPath.row) {
            cell.user = user
        }
        return cell
    }

    private func user(atIndex index: Int) -> User? {
        if users.count > index {
            return users[index]
        }
        return nil
    }

    private func deselectSelectedRow() {
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}

extension  UserSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.user(atIndex: indexPath.row) {
            self.showOkCancelAlert(withTitle: "Add to contacts?", message: "Do you want to add \(user.fullname) to your contact list?", style: UIAlertController.Style.actionSheet, onOkSelected: {
                self.presenter?.addToContacts(user)
                self.deselectSelectedRow()
            }, onCancelSelected: {
                self.deselectSelectedRow()
            })
        }
    }
}

extension UserSearchViewController: UISearchBarDelegate {

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchForUser(query: searchText)
    }
}

extension UserSearchViewController: UserSearchView {
    func onContactAdded(_ contact: User) {
        DispatchQueue.main.async {
            self.showToast("\(contact.fullname) has been added to your contact list.".localized)
        }
    }

    func onSearchError(_ error: AppErrors) {
        DispatchQueue.main.async {
            self.showError(error)
        }
    }

    func onContactAddedError() {
        DispatchQueue.main.async {
            self.showError(withTitle: "Error adding contact".localized, message: "Please try again".localized)
        }
    }

    func onSearchSetupError() {
        DispatchQueue.main.async {
            self.showError(withTitle: "Search failed".localized, message: "There was an error setting up your search. Please try again".localized)
        }
    }

    func refreshSearchList(_ users: [User]) {
        self.users = users
        DispatchQueue.main.async {
            self.showEmptyView(false)
            self.tableView.reloadData()
        }
    }

}

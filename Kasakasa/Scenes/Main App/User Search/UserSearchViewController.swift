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
    private var selectedUser: User? = nil
    private var lastSelectedIndexPath: IndexPath?
    var presenter: UserSearchPresenter?
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Find Contacts".localized
        presenter = UserSearchPresenter()
        presenter?.attach(self)

        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setRegularNavigationBar()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.close()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserProfile", let destination = segue.destination as? UserProfileViewController {
            destination.user = self.selectedUser
        }
    }
    private func showProfile(_ user: User) {
        self.performSegue(withIdentifier: "ShowUserProfile", sender: self)
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
        cell.delegate = self

        if let user = self.user(atIndex: indexPath.row) {
            cell.user = user
            debugPrint("******************* Setting up cell for user \(user.username) -> \(String(describing: user.isContact))")
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

extension  UserSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension  UserSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.user(atIndex: indexPath.row) {
            self.selectedUser = user
            self.showProfile(user)
//            self.showOkCancelAlert(withTitle: "Add to contacts?", message: "Do you want to add \(user.fullname) to your contact list?", style: UIAlertController.Style.actionSheet, onOkSelected: {
//                self.presenter?.addToContacts(user)
//                self.deselectSelectedRow()
//            }, onCancelSelected: {
//                self.deselectSelectedRow()
//            })
        }
    }
}

extension UserSearchViewController: UISearchBarDelegate {

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchForUser(query: searchText)
    }
}

extension UserSearchViewController: UserSearchView {
    func onContactAdded(_ contact: User) {
        if let indexPath = self.lastSelectedIndexPath {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        self.showToast("\(contact.fullname) has been added to your contact list.".localized)
    }

    func onSearchError(_ error: AppErrors) {
        self.showError(error)
    }

    func onContactAddedError() {
        self.showError(withTitle: "Error adding contact".localized, message: "Please try again".localized)
    }

    func onSearchSetupError() {
        self.showError(withTitle: "Search failed".localized, message: "There was an error setting up your search. Please try again".localized)
    }

    func refreshSearchList(_ users: [User]) {
        self.users = users
        self.showEmptyView(false)
        self.tableView.reloadData()
    }
}

extension UserSearchViewController: UserSearchCellDelegate {
    func actionButtonAction(forCell cell: UserSearchTableViewCell) {
        if let user = cell.user {
            lastSelectedIndexPath = self.tableView.indexPath(for: cell)
            presenter?.addToContacts(user)
        }
    }
}

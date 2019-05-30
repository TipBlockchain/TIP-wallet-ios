//
//  SelectContactViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-30.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class SelectContactViewController: BaseViewController {

    private var presenter: SelectContactPresenter?

    @IBOutlet private weak var tableView: UITableView!
    private var contacts: [User] = []
    let cellIdentifier = "ContactCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = SelectContactPresenter()
        presenter.attach(self)
        // Do any additional setup after loading the view.

        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setRegularNavigationBar()
    }
    
    deinit {
        presenter?.detach()
    }

    func onContactsFetched(_ contacts: [User]) {
        self.contacts = contacts
        self.tableView.reloadData()
    }

    func onContactsFetchError(_ error: AppErrors) {
        self.showError(error)
    }
}

extension SelectContactViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let contact = self.contact(atIndexPath: indexPath) {
            cell.imageView?.image = UIImage.placeHolderImage()
            cell.textLabel?.text = contact.username
            cell.detailTextLabel?.text = contact.fullname
        }
        return cell
    }

    func contact(atIndexPath indexPath: IndexPath) -> User? {
        if indexPath.row < contacts.count {
            return contacts[indexPath.row]
        }
        return nil
    }
}

extension SelectContactViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}

//
//  ContactsViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import GRDB

class ContactsViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var presenter: ContactsPresenter?
    private var controller: FetchedRecordsController<User>!
    private var contactRequest = User.orderedByFullname()
    private var selectedContact: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ContactsPresenter()
        presenter?.attach(self)
        presenter?.fetchContactList()
        self.configureTableView()
        // Do any additional setup after loading the view.
    }

    deinit {
        presenter?.detach()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setRegularNavigationBar()
    }

    private func configureTableView() {

        controller = try! FetchedRecordsController(AppDatabase.dbPool, request: contactRequest)

        controller.trackChanges(
            willChange: { [unowned self] (controller) in
                self.tableView.beginUpdates()
        }, onChange: { [unowned self] (controller, record, change) in

            switch change {
            case .insertion(let indexPath):
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            case .deletion(let indexPath):
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                break
            }
        }, didChange: { [unowned self] (controller) in
            self.tableView.endUpdates()
            self.showEmptyView(controller.fetchedRecords.isEmpty)
        })

        try? controller.performFetch()

        self.tableView.tableFooterView = UIView()
        self.showEmptyView(controller.fetchedRecords.isEmpty)

//        self.tableView.reloadData()
    }

    @IBAction func inviteFriendsTapped(_ sender: Any) {
        self.showContacts()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSendTransferFromContacts", let vc = segue.destination as? SendTransferViewController {
            vc.targetUser = self.selectedContact
        } else if segue.identifier == "ShowContactInfo", let vc = segue.destination as? UserProfileViewController {
            vc.user = self.selectedContact
        }
    }

    private func contact(atIndexPath indexPath: IndexPath) -> User? {
        return controller.record(at: indexPath)
    }

    private func showSendTransfer() {
        self.performSegue(withIdentifier: "ShowSendTransferFromContacts", sender: self)
    }

    private func showContactInfo() {
        self.performSegue(withIdentifier: "ShowContactInfo", sender: self)
    }
}

extension ContactsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedContact = self.contact(atIndexPath: indexPath) {
            self.showOkCancelAlert(withTitle: "Send Transfer?".localized, message: "Do you want to send a transfer to \(selectedContact.username)", style: .actionSheet, onOkSelected: {
                self.selectedContact = selectedContact
                self.showSendTransfer()
                tableView.deselectRow(at: indexPath, animated: true)
            }) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension ContactsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return controller.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.sections[section].numberOfRecords
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        cell.delegate = self
        if let contact = self.contact(atIndexPath: indexPath) {
            cell.user = contact
        }
        return cell
    }
}

extension ContactsViewController: ContactTableViewCellDelegate {
    func contactSelected(_ contact: User) {
        self.selectedContact = contact
        self.showContactInfo()
    }
}

extension ContactsViewController: ContactsView {
    func onContactsFetched(_ contancts: [User]) {
        self.tableView.reloadData()
    }

    func onNoContacts() {
//
    }

    func onContactsLoadError(_ error: AppErrors) {
//
    }

    func onContactsLoading() {

    }

    func onContactAdded(_ contact: User) {

    }

    func onContactRemoved(_ contact: User) {

    }

    func onContactAddError(_ error: AppErrors) {

    }

    func onContactRemoveError(_ error: AppErrors) {

    }
}

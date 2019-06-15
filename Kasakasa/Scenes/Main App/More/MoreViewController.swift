//
//  MoreViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-03.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

typealias VoidClosure = () -> Void
typealias MoreViewControllerClosure = (MoreViewController) -> Void


class MoreViewController: BaseViewController {

    struct MoreListItem {
        var title: String
        var icon: UIImage
        var cellIdentifier: String
        var action: VoidClosure
    }

    struct MoreListSection {
        var title: String
        var items: [MoreListItem]
    }

    @IBOutlet private var tableView: UITableView!

    private let profileCellIdentifier = "ProfileCell"
    private let socialCellIdentifier = "SocialCell"
    private let buyTipCellIdentifier = "BuyTipCell"
    private let signOutCellIdentifier = "SignOutCell"

    private var sections: [MoreListSection] = []

    private func makeSections() -> [MoreListSection] {
        return [
            MoreListSection(title: "My Account", items: [
                MoreListItem(title: "My Profile", icon: UIImage(named: "icon-guest-filled")!, cellIdentifier: socialCellIdentifier, action: {
                    self.showDetails(withSegueIdentifier: "ShowMyProfile")
                }),
                MoreListItem(title: "Settings", icon: UIImage(named: "icon-settings")!, cellIdentifier: socialCellIdentifier, action: {
                    self.showDetails(withSegueIdentifier: "ShowSettings")
                })
                ]),
            MoreListSection(title: "Trade TIP", items: [
                MoreListItem(title: "Trade TIP", icon: UIImage(named: "icon-stocks")!, cellIdentifier: socialCellIdentifier, action: {
                    self.showDetails(withSegueIdentifier: "ShowTradeTip")
                })
                ]),
            MoreListSection(title: "Join Our Community", items: [
                MoreListItem(title: "Telegram", icon: UIImage(named: "icon-telegram")!, cellIdentifier: socialCellIdentifier, action: {
                    self.openUrl(URL(string: "https://t.me/TipBlockchain")!)
                }),
                MoreListItem(title: "Twitter", icon: UIImage(named: "icon-twitter-filled")!, cellIdentifier: socialCellIdentifier, action: {
                    self.openUrl(URL(string: "twitter://user?screen_name=TipBlockchain")!, fallbackUrl: URL(string: "https://twitter.com/TipBlockchain")!)
                }),
                MoreListItem(title: "Facebook", icon: UIImage(named: "icon-facebook")!, cellIdentifier: socialCellIdentifier, action: {
                    self.openUrl(URL(string: "fb://profile/278043429395476")!, fallbackUrl: URL(string: "https://facebook.com/tipnetworkio"))
                }),
                MoreListItem(title: "Reddit", icon: UIImage(named: "icon-reddit")!, cellIdentifier: socialCellIdentifier, action: {
                    self.openUrl(URL(string: "https://www.reddit.com/r/TipBlockchain/")!)
                }),
                MoreListItem(title: "Invite friends", icon: UIImage(named: "icon-share")!, cellIdentifier: socialCellIdentifier, action: {
                    self.performShare()
                })
                ]),
            MoreListSection(title: "Sign Out", items: [
                MoreListItem(title: "Sign Out", icon: UIImage(named: "icon-exit")!, cellIdentifier: socialCellIdentifier, action: {
                    self.showOkCancelAlert(withTitle: "Are you sure you want to sign out?".localized,
                                           message: "Please make sure you have backed up your recovery phrase and password. You will lose access to your account if you sign out without first backing up.".localized,
                                           style: .alert,
                                           onOkSelected: {
                                            AppSession.signOut()
                                            self.navigateToOnboarding()
                                        },
                                           onCancelSelected: {

                                        })
                })
                ])
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        self.sections = makeSections()
        tableView.tableFooterView = UIView()

        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setRegularNavigationBar()
    }

    func showDetails(withSegueIdentifier segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    func performShare() {
        let text = "Check out Kasakasa crypto wallet from TIP blockchain. You can send and receive crypto usign usernames https://tipblockchain.io/kasakasa"
        let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = self.view
        self.present(activity, animated: true, completion: nil)
    }
}

extension MoreViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sections.count {
            return sections[section].items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let item = self.item(atIndexPath: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellIdentifier, for: indexPath)
            cell.textLabel?.text = item.title
            cell.imageView?.image = item.icon.resized(CGSize(width: 28.0, height: 28.0))
            return cell
        }

        return UITableViewCell()
    }

    private func section(atIndex index: Int) -> MoreListSection? {
        if index < sections.count {
            return sections[index]
        }
        return nil
    }

    private func section(atIndexPath indexPath: IndexPath) -> MoreListSection? {
        return self.section(atIndex: indexPath.section)
    }

    private func item(atIndexPath indexPath: IndexPath) -> MoreListItem? {
        if let section = self.section(atIndexPath: indexPath) {
            if section.items.count > indexPath.row {
                return section.items[indexPath.row]
            }
        }

        return nil
    }
}

extension MoreViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let s = self.section(atIndex: section) {
            return s.title
        }

        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = self.item(atIndexPath: indexPath) {
            item.action()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


extension MoreViewController: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            showToast("Message sent".localized)
        case .failed:
            showOkAlert(withTitle: "Oops".localized, message: "An error occured while sending the message. Please try again later.".localized)
        default:
            break
        }
    }
}

//
//  MoreViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-03.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

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
                MoreListItem(title: "Trade TIP", icon: UIImage(named: "icon-buy")!, cellIdentifier: socialCellIdentifier, action: {
                    self.showDetails(withSegueIdentifier: "ShowTradeTip")
                })
            ]),
            MoreListSection(title: "Join Our Community", items: [
                MoreListItem(title: "Telegram", icon: UIImage(named: "icon-telegram")!, cellIdentifier: socialCellIdentifier, action: {

                }),
                MoreListItem(title: "Twitter", icon: UIImage(named: "icon-twitter-filled")!, cellIdentifier: socialCellIdentifier, action: {

                }),
                MoreListItem(title: "Facebook", icon: UIImage(named: "icon-facebook")!, cellIdentifier: socialCellIdentifier, action: {

                }),
                MoreListItem(title: "Reddit", icon: UIImage(named: "icon-reddit")!, cellIdentifier: socialCellIdentifier, action: {

                }),
                MoreListItem(title: "Invite friends", icon: UIImage(named: "icon-share")!, cellIdentifier: socialCellIdentifier, action: {

                })
            ]),
            MoreListSection(title: "Sign Out", items: [
                MoreListItem(title: "Sign Out", icon: UIImage(named: "icon-exit")!, cellIdentifier: socialCellIdentifier, action: {

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

    func showDetails(withSegueIdentifier segueIdentifier: String) {
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

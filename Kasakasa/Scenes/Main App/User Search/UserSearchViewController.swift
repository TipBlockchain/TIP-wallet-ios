//
//  UserSearchViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class UserSearchViewController: ModalViewController {

    private var contacts: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension UserSearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userSearchCell", for: indexPath)
        return cell
    }


}

extension UserSearchViewController: UISearchBarDelegate {

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
}

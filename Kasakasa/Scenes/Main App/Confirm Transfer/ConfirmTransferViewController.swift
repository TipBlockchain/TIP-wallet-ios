//
//  ConfirmTransferViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-14.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class ConfirmTransferViewController: BaseViewController {

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendTransferTapped(_ sender: Any) {
    }

    private enum  ConfirmTransferCell: String {
        case toCell, fromCell, amountCell, networkFeeCell, totalCell, none
    }
}

extension ConfirmTransferViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(forIndexPath: indexPath).rawValue, for: indexPath)
        return cell
    }

    private func cellIdentifier(forIndexPath indexPath: IndexPath) -> ConfirmTransferCell {
        switch indexPath.row {
        case 0:
            return .toCell
        case 1:
            return .fromCell
        case 2:
            return .amountCell
        case 3:
            return .networkFeeCell
        case 4:
            return .totalCell
        default:
            return .none
        }
    }
}

//
//  WalletListTableViewCell.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class WalletListTableViewCell: UITableViewCell {

    var wallet: Wallet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateUI() {
        if let wallet = self.wallet {
            logoImageView.image = UIImage(named: "coin-logo-\(wallet.currency.rawValue.lowercased())")
            titleLabel.text = wallet.currency.name
            let formattedBalance = EthConvert.formattedValue(wallet.balance, decimals: 2)
            balanceLabel.text = "\(formattedBalance) \(wallet.currency.symbol)"
        }
    }

}

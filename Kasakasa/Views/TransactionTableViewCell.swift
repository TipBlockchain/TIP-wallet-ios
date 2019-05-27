//
//  TransactionTableViewCell.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-25.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import BigInt
import Nuke

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var transaction: Transaction? {
        didSet {
            self.updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateUI() {
        self.usernameLabel.text = transaction?.from ?? ""
        if let valueString = EthConvert.toEthereumUnits(transaction?.value ?? BigUInt("0"), decimals: 3), let currency = transaction?.currency {
            self.amountLabel.text = valueString  + " " + currency
        } else {
            self.amountLabel.text = ""
        }
        self.messageLabel.text = transaction?.fromUser?.fullname ?? ""
        if let txDate = transaction?.timestamp {
            self.dateLabel.text = DateFormatter.displayDateFormatter.string(from: txDate)
        } else {
            self.dateLabel.text = ""
        }
        if let photoUrl = transaction?.fromUser?.photoUrl, let imageUrl = URL(string: photoUrl) {
            Nuke.loadImage(with: imageUrl, into: self.userImageView)
        } else {
            userImageView.image = UIImage.placeHolderImage()
        }
    }
    
}

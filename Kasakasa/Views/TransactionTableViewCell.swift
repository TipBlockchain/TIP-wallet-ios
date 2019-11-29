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
    var wallet: Wallet?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateUI() {
        guard let transaction = transaction else {
            return
        }

        let outgoingTx = transaction.from.lowercased() == wallet?.address.lowercased()

        self.usernameLabel.text = outgoingTx ?
            (transaction.toUser != nil ? transaction.toUser?.username?.withAtPrefix() : transaction.to) :
            (transaction.fromUser != nil ? transaction.fromUser?.username?.withAtPrefix() : transaction.from)
        let photoUrl = outgoingTx ? transaction.toUser?.originalPhotoUrl : transaction.fromUser?.originalPhotoUrl
        if let photoUrl = photoUrl, let imageUrl = URL(string: photoUrl) {
            Nuke.loadImage(with: imageUrl, into: self.userImageView)
        } else {
            userImageView.image = UIImage.placeHolderImage()
        }

        if let valueString = EthConvert.toEthereumUnits(transaction.value, decimals: 3), let currency = transaction.currency {
            self.amountLabel.text = valueString  + " " + currency
        } else {
            self.amountLabel.text = "Pending".localized
        }
        self.amountLabel.textColor = outgoingTx ? .outRed : .inGreen
        self.messageLabel.text = transaction.fromUser?.fullname ?? ""
        let txDate = transaction.timestamp
        self.dateLabel.text = DateFormatter.displayDateFormatter.string(from: txDate)


    }
    
}

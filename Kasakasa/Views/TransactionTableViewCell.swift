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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var amountLabel: UILabel!
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

        if outgoingTx {
            if let recipient = transaction.toUser {
                self.titleLabel.text = recipient.fullname ?? ""
                self.subtitleLabel.text = recipient.username?.withAtPrefix() ?? ""
            } else {
                self.titleLabel.text = transaction.to
                self.subtitleLabel.text = ""
            }
        } else {
            if let sender = transaction.fromUser {
                self.titleLabel.text = sender.fullname ?? ""
                self.subtitleLabel.text = sender.username?.withAtPrefix() ?? ""
            } else {
                self.titleLabel.text = transaction.from
                self.subtitleLabel.text = ""
            }
        }

        let photoUrl = outgoingTx ? transaction.toUser?.originalPhotoUrl : transaction.fromUser?.originalPhotoUrl
        if let photoUrl = photoUrl, let imageUrl = URL(string: photoUrl) {
            Nuke.loadImage(with: imageUrl, into: self.userImageView)
        } else {
            userImageView.image = UIImage.placeHolderImage()
        }

        let formattedValue = EthConvert.formattedValue(transaction.value, decimals: 3)
        if let currency = transaction.currency {
            self.amountLabel.text = formattedValue  + " " + currency
        } else {
            self.amountLabel.text = "Pending".localized
        }
        self.amountLabel.textColor = outgoingTx ? .outRed : .inGreen
        let txDate = transaction.timestamp
        self.dateLabel.text = DateFormatter.displayDateFormatter.string(from: txDate)
    }
    
}

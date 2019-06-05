//
//  CryptoExchangeTableViewCell.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class CryptoExchangeTableViewCell: UITableViewCell {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    var exchange: CryptoExchange? {
        didSet {
            updateUI()
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
        if let exchange = self.exchange {
            self.titleLabel.text = exchange.displayName
            if let image = exchange.logoImage {
                self.backgroundImageView.image = image
            } else if let imageUrlString = exchange.logoUrl, let logoUrl = URL(string: imageUrlString) {
                Nuke.loadImage(with: logoUrl, into: self.backgroundImageView)
            }
        } else {
            self.titleLabel.text = ""
            self.backgroundImageView.image = nil
        }
    }
}

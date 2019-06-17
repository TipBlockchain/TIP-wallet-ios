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
    @IBOutlet private weak var shadowView: UIView!

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
            self.shadowView.addShadow(offset: CGSize(width: 2.0, height: 5.0), radius: 5.0, opacity: 0.9)
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

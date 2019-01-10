//
//  CountryTableViewCell.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    var country: Country? {
        didSet {
            imageView?.image = country?.flagImage
            textLabel?.text = country?.nameWithCountryCode ?? ""
            self.setNeedsDisplay()
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
    
}

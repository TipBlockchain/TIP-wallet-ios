//
//  ContactTableViewCell.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-14.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

protocol ContactTableViewCellDelegate: class {
    func contactSelected(_ contact: User)
}

class ContactTableViewCell: UITableViewCell {
    var user: User? {
        didSet {
            fullnameLabel.text = user?.fullname ?? ""
            usernameLabel.text = user?.username ?? ""
            if let user = user, let imageUrlString = user.originalPhotoUrl, let imageUrl = URL(string: imageUrlString) {
                let placeholderImage = UIImage.placeHolderImage()
                let loadOptions = ImageLoadingOptions(placeholder: placeholderImage, transition: ImageLoadingOptions.Transition.fadeIn(duration: 0.33), failureImage: placeholderImage, failureImageTransition: .fadeIn(duration: 0.33))
                debugPrint("loading image from \(imageUrl)")
                Nuke.loadImage(with: imageUrl, options: loadOptions, into: displayImageView)
            }
            self.setNeedsDisplay()
        }
    }

    @IBOutlet var fullnameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var displayImageView: UIImageView!

    weak var delegate: ContactTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addTapGestureRecognizer()
    }

    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(displayImageTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.displayImageView.addGestureRecognizer(tapGesture)
    }

    @objc public func displayImageTapped(_ sender: Any) {
        if let user = self.user {
            self.delegate?.contactSelected(user)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

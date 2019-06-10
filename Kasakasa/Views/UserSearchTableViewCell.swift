//
//  UserSearchTableViewCell.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-13.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

protocol UserSearchCellDelegate: class {
    func actionButtonAction(forCell cell: UserSearchTableViewCell)
}
class UserSearchTableViewCell: UITableViewCell {

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

    weak var delegate: UserSearchCellDelegate?

    @IBOutlet private var fullnameLabel: UILabel!
    @IBOutlet private var usernameLabel: UILabel!
    @IBOutlet private var displayImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction private func actionButtonTapped(_ sender: Any) {
        self.delegate?.actionButtonAction(forCell: self)
    }

}

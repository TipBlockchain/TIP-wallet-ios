//
//  ReceiveTransferViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-16.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class ReceiveTransferViewController: BaseViewController {

    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    let currentUser = UserRepository.shared.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationItem.leftItemsSupplementBackButton = true
        if currentUser == nil {
            self.showOkAlert(withTitle: "Error reading wallet information".localized, message: "There was a problem reading your wallet information. Please close the app and try again.".localized, style: .alert) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.setupViews()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBarTransparent()

    }
    private func setupViews() {
        guard let currentUser = self.currentUser else { return }

        if let urlString = self.currentUser?.originalPhotoUrl, let url = URL(string: urlString) {
            Nuke.loadImage(with: url, into: self.displayImageView)
        }
        usernameLabel.text = currentUser.username
        addressLabel.text = currentUser.address

        qrCodeImageView.image = UIImage.qrCode(fromString: currentUser.address, scaleX: 10.0, scaleY: 10.0) //
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func copyAddressTapped(_ sender: Any) {
        if let address = addressLabel.text {
            self.copyToClipboard(address)
            self.showToast("Address copied".localized)
        }
    }
    
}

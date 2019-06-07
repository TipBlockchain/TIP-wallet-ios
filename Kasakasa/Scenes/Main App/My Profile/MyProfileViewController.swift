//
//  MyProfileViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class MyProfileViewController: BaseViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var aboutMeField: UITextField!

    private let cellIdentifier = "ProfileCellIdentifier"
    private var imageCropper: ImageCropperViewController?
    private var presenter: MyProfilePresenter?

    private var user: User?

    var imagePicker: ImagePicker!

    private enum MyProfileCell: String {
        case usernameCell, fullnameCell, phoneNumberCell, aboutMeCell, emptyCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MyProfilePresenter()
        presenter?.attach(self)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.user = UserRepository.shared.currentUser
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    deinit {
        self.imageCropper = nil
        self.presenter?.detach()
        self.presenter = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarTransparent()
    }

    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    private func setupUI() {
        self.usernameLabel.text = self.user?.username
        if let urlString = self.user?.originalPhotoUrl, let url = URL(string: urlString) {
            Nuke.loadImage(with: url, into: self.profileImageView)
        }
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }

    private func configureCropper(forImage image: UIImage) {
        var config = ImageCropperConfiguration(with: image, and: .square)
        config.maskFillColor = UIColor.black.withAlphaComponent(0.5)
        config.borderColor = UIColor.black

        config.showGrid = true
        config.gridColor = UIColor.white
        config.doneTitle = "Crop"
        config.cancelTitle = "Cancel"

        let imageCropper = ImageCropperViewController.initialize(with: config) { croppedImage in
            if let croppedImage = croppedImage {
                self.profileImageView.image = croppedImage
                self.presenter?.uploadPhoto(croppedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(imageCropper, animated: false, completion: nil)
    }

    func onProfileUpdated(_ user: User) {
        self.showToast("Profile photo updated.".localized)
    }

    func onPhotoUploadError(_ error: AppErrors) {
        self.showError(error)
    }
}

extension MyProfileViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        if let image = image {
            self.configureCropper(forImage: image)
        }
    }
}

extension MyProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = self.identifier(forIndexPath: indexPath).rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }

    private func identifier(forIndexPath indexPath: IndexPath) -> MyProfileCell {
        switch indexPath.row {
        case 0:
            return .usernameCell
        case 1:
            return .fullnameCell
        case 2:
            return .phoneNumberCell
        case 3:
            return .aboutMeCell
        default:
            return .emptyCell
        }
    }
}

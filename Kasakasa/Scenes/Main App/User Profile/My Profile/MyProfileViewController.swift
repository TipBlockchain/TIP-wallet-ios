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
    @IBOutlet weak var profileImageActivityIndicator: UIActivityIndicatorView!
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
        self.user = UserRepository.shared.currentUser

        self.presenter = MyProfilePresenter()
        presenter?.attach(self)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.usernameLabel.text = ""

        self.addGestureRecognizers()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupUI()
    }

    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }

    private func setupUI() {
        self.usernameLabel.text = self.user?.username.withAtPrefix()
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
//                self.profileImageView.image = croppedImage
                self.profileImageActivityIndicator.startAnimating()
                self.presenter?.uploadPhoto(croppedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(imageCropper, animated: false, completion: nil)
    }

    func onProfileUpdated(_ user: User) {
        self.profileImageActivityIndicator.stopAnimating()
        self.showToast("Profile photo updated.".localized)
        self.user = user
        self.setupUI()
    }

    func onPhotoUploadError(_ error: AppErrors) {
        self.profileImageActivityIndicator.stopAnimating()
        self.showError(error)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowImageFromMyProfile", let vc = segue.destination as? ImageViewController,
            let profilePicUrl = self.user?.originalPhotoUrl,
            let url = URL(string: profilePicUrl) {
            vc.imageUrl = url
        }
    }

    private func showEditFullname() {
        self.performSegue(withIdentifier: "ShowEditFullname", sender: self)
    }

    private func showEditAboutMe() {
        self.performSegue(withIdentifier: "ShowEditAboutMe", sender: self)
    }

    @objc private func showProfilePicture(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowImageFromMyProfile", sender: self)
    }

    private func addGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfilePicture(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.profileImageView.addGestureRecognizer(tapGesture)
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
        self.setOutlet(forCell: cell, atIndexPath: indexPath)
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

    private func setOutlet(forCell cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let cellIdentifier = self.identifier(forIndexPath: indexPath)

        switch cellIdentifier {
        case .usernameCell:
            self.usernameField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
            self.usernameField.text = user?.username.withAtPrefix()
        case .fullnameCell:
            self.fullnameField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
            fullnameField.text = user?.fullname
        case .phoneNumberCell:
            self.phoneNumberField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
            phoneNumberField.text = user?.phoneNumberString
        case .aboutMeCell:
            self.aboutMeField = cell.contentView.subView(ofType: UITextField.self) as? UITextField
            self.aboutMeField.text = user?.aboutMe
        default:
            break
        }
    }
}

extension MyProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIdentifier = self.identifier(forIndexPath: indexPath)
        switch cellIdentifier {
        case .fullnameCell:
            self.showEditFullname()
        case .aboutMeCell:
            self.showEditAboutMe()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

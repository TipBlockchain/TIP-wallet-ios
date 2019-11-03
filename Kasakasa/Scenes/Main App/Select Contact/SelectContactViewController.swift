//
//  SelectContactViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-30.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class SelectContactViewController: BaseViewController {

    private var presenter: SelectContactPresenter?

    @IBOutlet private weak var tableView: UITableView!
    private var contacts: [User] = []
    let cellIdentifier = "ContactCellIdentifier"
    var delegate: SelectContactDelegate?

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)

            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = true
            $0.showOverlayView        = true
//            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.3, width: 0.6, height: 0.3)
        }
        let reader = QRCodeReaderViewController(builder: builder)
        return reader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = SelectContactPresenter()
        presenter.attach(self)
        // Do any additional setup after loading the view.


        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setRegularNavigationBar()
    }
    
    deinit {
        presenter?.detach()
    }

    func onContactsFetched(_ contacts: [User]) {
        self.contacts = contacts
        self.tableView.reloadData()
    }

    func onContactsFetchError(_ error: AppErrors) {
        self.showError(error)
    }

    @IBAction private func scanQrCodeTapped(_ sender: Any) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self

        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            debugPrint(result?.metadataType)
            print(result?.value)
        }

        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet

        present(readerVC, animated: true, completion: nil)
    }
}

extension SelectContactViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactTableViewCell
        if let contact = self.contact(atIndexPath: indexPath) {
            cell.user = contact
        }
        return cell
    }

    func contact(atIndexPath indexPath: IndexPath) -> User? {
        if indexPath.row < contacts.count {
            return contacts[indexPath.row]
        }
        return nil
    }
}

extension SelectContactViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        if let contact = self.contact(atIndexPath: indexPath) {
            self.delegate?.contactSelected(contact)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}

// MARK: - QRCodeReaderViewController Delegate Methods

extension SelectContactViewController: QRCodeReaderViewControllerDelegate {

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }

    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
         let cameraName = newCaptureDevice.device.localizedName
        debugPrint("Switching capture to: \(cameraName)")
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        dismiss(animated: true, completion: nil)
    }
}

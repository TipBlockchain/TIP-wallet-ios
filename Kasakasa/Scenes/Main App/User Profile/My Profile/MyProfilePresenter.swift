//
//  MyProfilePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class MyProfilePresenter: BasePresenter {
    typealias View = MyProfileViewController
    var view: MyProfileViewController?
    let tipApi = TipApiService.sharedInstance
    let mainQueue = DispatchQueue.main

    func uploadPhoto(_ image: UIImage) {
        UserRepository.shared.updatePhoto(image, completion: { (user, error) in
            self.mainQueue.async {
                if let user = user {
                    debugPrint("Updated user = \(user)")
                    self.view?.onProfileUpdated(user)
                } else {
                    self.view?.onPhotoUploadError(error ?? AppErrors.genericError(message: "Error uploading photo".localized))
                }
            }
        })
    }
}

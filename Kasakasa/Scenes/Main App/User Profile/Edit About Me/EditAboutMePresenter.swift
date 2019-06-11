//
//  EditAboutMePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class EditAboutMePresenter: BasePresenter {
    typealias View = EditAboutMeViewController
    weak var view: EditAboutMeViewController?
    private let mainQueue = DispatchQueue.main

    func updateAboutMe(_ aboutMe: String) {
        UserRepository.shared.updateAboutMe(aboutMe) { (user, error) in
            self.mainQueue.async {
                if user != nil {
                    self.view?.onAboutMeUpdated()
                } else {
                    self.view?.onAboutMeError(error ?? AppErrors.unknowkError)
                }
            }
        }
    }
}

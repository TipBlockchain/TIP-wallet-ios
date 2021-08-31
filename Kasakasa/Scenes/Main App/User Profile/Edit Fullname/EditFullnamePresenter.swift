//
//  EditFullnamePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-09.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class EditFullnamePresenter: BasePresenter {

    typealias View = EditFullnameViewController

    weak var view: EditFullnameViewController?

    private let mainQueue = DispatchQueue.main

    func updateFullname(_ fullname: String) {
        UserRepository.shared.updateFullname(fullname) { (user, error) in
            self.mainQueue.async {
                if user != nil {
                    self.view?.onFullnameUpdated()
                } else {
                    self.view?.onFullnameUpdateError(error ?? AppErrors.unknowkError)
                }
            }
        }
    }
}

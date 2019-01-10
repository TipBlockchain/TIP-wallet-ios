//
//  BasePresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-07.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

protocol BasePresenter {

    associatedtype View
    var view: View? { get set }
}

extension BasePresenter {

    mutating func attach(_ v: View) {
        self.view = v
    }

    mutating func detach() {
        self.view = nil
    }
}

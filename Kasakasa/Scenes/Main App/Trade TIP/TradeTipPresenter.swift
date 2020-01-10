//
//  TradeTipPresenter.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-12-11.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class TradeTipPresenter: BasePresenter {
    typealias View = TradeTipViewController

    weak var view: TradeTipViewController?
    lazy var api = TipApiService.sharedInstance

    public func getExchanges() {
        api.getExchanges(["isActive": "true"]) { (exchanges, error) in
            DispatchQueue.main.async {
                if let exchanges = exchanges {
                    self.view?.setExchanges(exchanges)
                } else if let error = error {
                    self.view?.showError(error)
                } else {
                    self.view?.showError(AppErrors.unknowkError)
                }
            }
        }
    }

}

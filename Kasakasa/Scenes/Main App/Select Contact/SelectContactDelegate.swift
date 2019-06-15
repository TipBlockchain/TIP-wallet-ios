//
//  SelectContactDelegate.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-05-31.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation


protocol SelectContactDelegate {
    func contactSelected(_ user: User)
    func addressEntered(_ address: String)
}

//
//  BaseViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-08.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import ToastSwiftFramework

typealias VoidCompletionBlock = (() -> Void)
typealias StringCompletionBlock = ((String?) -> Void)

class BaseViewController: UIViewController {

    @IBOutlet private weak var emptyView: UIView?

    private var activityIndicator: UIActivityIndicatorView?

    private var _tapGestureRecognizer: UITapGestureRecognizer?
    private var endEditingGestureRecognizer: UITapGestureRecognizer {
        if _tapGestureRecognizer == nil {
            _tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
            _tapGestureRecognizer?.numberOfTapsRequired = 1
        }
        return _tapGestureRecognizer!
    }

    var endEditingOnTap: Bool = false {
        didSet {
            if endEditingOnTap {
                self.view.addGestureRecognizer(endEditingGestureRecognizer)
            } else {
                self.view.removeGestureRecognizer(endEditingGestureRecognizer)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func showActivityIndicator(_ show: Bool = true) {
        if show, activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .gray)
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.center = self.view.center
            self.view.addSubview(activityIndicator!)
        }

        if show, let activityIndicator = activityIndicator {
            self.view.bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }

    func showEmptyView(_ show: Bool) {
        UIView.animate(withDuration: 0.5) {
            if show {
                self.emptyView?.alpha = 1.0
            } else {
                self.emptyView?.alpha = 0.0
            }
            self.emptyView?.isHidden = !show
        }
    }
}

protocol MyP {
    var myVar: String { get }
}

extension MyP {
    var  myVar: String {
        return "Str"
    }
}

class MyC: MyP {
    func myFunc() {
        debugPrint("MyVar = \(myVar)")
    }
}

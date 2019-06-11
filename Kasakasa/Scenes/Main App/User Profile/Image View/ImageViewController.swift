//
//  ImageViewController.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-06-11.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Nuke

class ImageViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    var imageUrl: URL?
    var imageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl = self.imageUrl {
            Nuke.loadImage(with: imageUrl, into: self.imageView)
        } else if let imageName = self.imageName {
            self.imageView.image = UIImage(named: imageName)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

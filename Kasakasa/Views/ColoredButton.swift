//
//  ColoredButton.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-10.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class ColoredButton: UIButton {

    private var originalBackgroundColor: UIColor!
    private var originalTitleColor: UIColor!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.originalBackgroundColor = self.backgroundColor
        self.originalTitleColor = self.titleColor(for: .normal)
        self.setTitleColor(self.titleColor(for: .normal)?.darker(by: 0.15), for: .highlighted)
    }

    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? self.originalBackgroundColor.darker(by: 0.2) : self.originalBackgroundColor
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

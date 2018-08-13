//
//  CloseButton.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-13.
//  Copyright © 2018 nil. All rights reserved.
//

import UIKit

class CloseButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    private func commonInit() {
        self.setTitle("✕", for: .normal)
        self.layer.cornerRadius = self.frame.size.width / 2
        self.backgroundColor = ColorPalette.translucentLightGray
    }
}

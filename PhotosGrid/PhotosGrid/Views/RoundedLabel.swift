//
//  RoundedLabel.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-12.
//  Copyright © 2018 nil. All rights reserved.
//

import UIKit

class RoundedLabel: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        self.font = UIFont(name: "Avenir-Black", size: 16.0)
        self.textColor = .white
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.3
        self.textAlignment = .center
    }
    
    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        return CGSize(width: defaultSize.width + 12, height: defaultSize.height + 8)
    }
}

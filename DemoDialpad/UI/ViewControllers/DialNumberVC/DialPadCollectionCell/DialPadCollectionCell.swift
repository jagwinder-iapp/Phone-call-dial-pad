//
//  DialPadCollectionCell.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

class DialPadCollectionCell: UICollectionViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var numberPadView : NumberPadButton!
    
    //MARK: CollectionViewCell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    //MARK: UI Related Methods
    private func setupAppearance() {
        
//        self.numberPadView.layer.cornerRadius = 50
//        self.numberPadView.borderColor = UIColor.NumberPadBG
        self.numberPadView.borderWidth = 0.0
        self.numberPadView.highlightColor = UIColor.appGray
        self.numberPadView.backgroundColor = UIColor.lightAppGray
        numberPadView.padFont = UIFont.figtreeRegular(ofSize: 35)
        numberPadView.textColor = .black
    }
}

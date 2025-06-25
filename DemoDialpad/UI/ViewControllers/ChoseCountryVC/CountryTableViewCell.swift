//
//  CountryTableViewCell.swift
//  SecondLine
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var imageVieww: UIImageView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dialCodeLabelOuterView: UIView!
    @IBOutlet weak var dialCodeLabel: UILabel!
        
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    var ignoreColor = true
    
    //MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        setUPFont()
        setupBackgroundView()
        imageVieww.layer.cornerRadius = imageVieww.frame.height/2
        dialCodeLabelOuterView.layer.cornerRadius = 12
        mainContainer.layer.cornerRadius = 10
        mainContainer.backgroundColor = .lightAppGray
    }
    
    // MARK: - Setup Methods
    func setUPFont() {
        titleLabel.font = UIFont.figtreeBold(ofSize: 18)
        dialCodeLabel.font = UIFont.figtreeBold(ofSize: 14)
    }
    
    func setupBackgroundView() {
        mainContainer.layer.borderColor = UIColor.clear.cgColor
        mainContainer.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if !ignoreColor {
            self.mainContainer.backgroundColor = selected ? .accent : .clear
        }
    }
    
    //MARK: - UI Methods
    func updateUI() {
        self.titleLabel.font = UIFont.figtreeBold(ofSize: 18)
        self.dialCodeLabel.font = UIFont.figtreeBold(ofSize: 15)
    }

    func resetBGCOlor() {
        self.mainContainer.backgroundColor =  .clear
    }
}



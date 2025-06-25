//
//  CallOptionsCollectionViewCell.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

// MARK: - Class Definition
class CallOptionsCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var acceptCallImageView: UIImageView!
    @IBOutlet weak var placeCallButton: UIButton!
    @IBOutlet weak var backSpaceButton: UIButton!

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    // MARK: - View Setup
    private func setUpView(){
        bgView.backgroundColor = .clear
    }
    
    // MARK: - Backspace Visibility
    func updateBackspaceVisibility(isVisible: Bool) {
        backSpaceButton.isHidden = !isVisible
    }
    
    // MARK: - Button Animation
    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = CGAffineTransform.identity
            }
        })
    }
}

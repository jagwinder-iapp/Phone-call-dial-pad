//
//  PadButton.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

// Used from https://github.com/RustyKnight/DialPad
@IBDesignable public class PadButton: UIControl {
	
    @IBInspectable public var borderColor: UIColor = .black {
		didSet {
            layer.borderColor = borderColor.cgColor
		}
	}
    
    @IBInspectable public var highlightColor: UIColor = .black {
        didSet {
            if filled {
                layer.backgroundColor = highlightColor.cgColor
            }
        }
    }
	
	@IBInspectable public var borderWidth: CGFloat {
		set { layer.borderWidth = newValue }
		get { layer.borderWidth }
	}
	
	@IBInspectable public var filled: Bool = false {
		didSet {
			if filled {
                layer.backgroundColor = borderColor.cgColor
			} else {
				layer.backgroundColor = nil
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		borderWidth = 1
        borderColor = .black
        highlightColor = borderColor
        isOpaque = false
		clipsToBounds = true
	}
	
    internal var touchDuration: TimeInterval = 0.4

    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        let duration = touchDuration
        
        let fromColor = highlightColor.cgColor
        let toColor = UIColor.lightAppGray.cgColor
        
        layer.backgroundColor = fromColor
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.duration = duration
        animation.fromValue = fromColor
        animation.toValue = toColor
        layer.add(animation, forKey: "backgroundColor")
        
        layer.backgroundColor = toColor
        
        self.sendActions(for: .valueChanged)
        
        return true
    }

	
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
		return false
	}
	
}

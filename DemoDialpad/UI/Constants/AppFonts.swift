//
//  AppFonts.swift
//  DemoDialpad
//
//  Created by iapp on 18/06/25.
//

import UIKit

extension UIFont {
    static func figtreeLight(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Figtree-Light", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func figtreeRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Figtree-Regular", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func figtreeMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Figtree-Medium", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func figtreeSemiBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Figtree-SemiBold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func figtreeBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Figtree-Bold", size: size) ?? .systemFont(ofSize: size)
    }
    
    static func figtreeExtraBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Figtree-ExtraBold", size: size) ?? .systemFont(ofSize: size)
    }
}

//
//  EditMenuOptions.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import Foundation
import MenuItemKit

protocol EditMenuOptionsProtocol: NSObject {
    func didSelectMenuItem(_ option: EditOptionType)
}

enum EditOptionType {
    case copy, paste
    
    var title: String {
        switch self {
        case .copy:
            return "Copy"
        case .paste:
            return "Paste"
        }
    }
}

class EditMenuOptionsController: NSObject {
    private var editOptions = [EditOptionType]()
    private var superview = UIView()
    
    weak var delegate: EditMenuOptionsProtocol?
    
    func show(on superview: UIView, options: [EditOptionType]) {
        editOptions = options
        self.superview = superview
        let frame = superview.bounds
        
        if #available(iOS 16.0, *) {
            let position = CGPoint(x: frame.minX + frame.width/2, y: frame.minY)
            let configuration = UIEditMenuConfiguration(identifier: nil, sourcePoint: position)
            let editMenuInteraction = UIEditMenuInteraction(delegate: self)
            
            superview.addInteraction(editMenuInteraction)
            editMenuInteraction.presentEditMenu(with: configuration)
        } else {
            var menuItems:[UIMenuItem] = []
            for option in options {
                let imageItem = UIMenuItem(title: option.title, image: UIImage(named: "")) { [weak self] _ in
                    self?.delegate?.didSelectMenuItem(option)
                }
                menuItems.append(imageItem)
            }
            UIMenuController.shared.menuItems = menuItems
            
            //            if #available(iOS 13.0, *) {
            //                UIMenuController.shared.showMenu(from: superview, rect: frame)
            //            } else {
            UIMenuController.shared.setTargetRect(frame, in: superview)
            //            }
        }
    }
    
    func hideMenu() {
        if #available(iOS 16.0, *) {
            if let interaction = superview.interactions.first(where: { $0 is UIEditMenuInteraction }) as? UIEditMenuInteraction {
                interaction.dismissMenu()
            }
        } else {
            if UIMenuController.shared.isMenuVisible {
                //            if #available(iOS 13.0, *) {
                //                UIMenuController.shared.hideMenu()
                //            } else {
                UIMenuController.shared.setTargetRect(CGRect.zero, in: superview)
                UIMenuController.shared.setMenuVisible(false, animated: false)
                //            }
            }
        }
    }
}

//MARK: - UIEditMenuInteractionDelegate
@available(iOS 16.0, *)
extension EditMenuOptionsController: UIEditMenuInteractionDelegate {
    func editMenuInteraction(_ interaction: UIEditMenuInteraction,
                             menuFor configuration: UIEditMenuConfiguration,
                             suggestedActions: [UIMenuElement]) -> UIMenu? {
        
        let menuItemsArray: [UIMenu] = editOptions.map { option in
            UIMenu(title: "", options: .displayInline, children: [
                UIAction(title: option.title, image: nil) { [weak self] _ in
                    self?.delegate?.didSelectMenuItem(option)
                }
            ])
        }

        return UIMenu(children: menuItemsArray)
    }
}

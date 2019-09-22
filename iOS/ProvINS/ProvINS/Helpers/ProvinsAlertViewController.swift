//
//  ProvinsAlertViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import UIKit

class ProvinsAlertViewController {
    
    class func present(title: String, message: String, okTitle: String? = "OK", from presentingViewController: UIViewController? = nil, okAction: (()->Void)? = nil) -> [UIAlertAction] {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        // Customize the title and message labels
        let titleFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 18)! ]
        let messageFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 14)! ]
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        // Customize the alert action label
        let alertAction = UIAlertAction(title: okTitle, style: .default, handler: { (alertAction) in okAction?() })
        
        alertAction.setValue(UIColor.primaryColor(), forKey: "titleTextColor")
        alertController.addAction(alertAction)
        
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
        return [alertAction]
    }
    
    class func present(title: String, message: String, okTitle: String, cancelTitle: String, from presentingViewController: UIViewController? = nil, okAction: @escaping () -> Void) -> [UIAlertAction] {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let titleFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 18)! ]
        let messageFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 14)! ]
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { _ in okAction() } )
        okAction.setValue(UIColor.primaryColor(), forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        cancelAction.setValue(UIColor.primaryColor(), forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
        return [okAction, cancelAction]
    }
    
    class func presentWithTextField(title: String, message: String, okTitle: String, cancelTitle: String, from presentingViewController: UIViewController? = nil, okAction: @escaping (_ text: String?) -> Void) -> [UIAlertAction] {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let titleFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 18)! ]
        let messageFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 14)! ]
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { alertAction in
            let textField = alertController.textFields![0]
            if let text = textField.text {  okAction(text) } else {
                okAction(nil)
            }
        } )
        alertController.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.numberPad
            textField.placeholder = "Enter your mobile number"
        }
        okAction.setValue(UIColor.primaryColor(), forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        cancelAction.setValue(UIColor.primaryColor(), forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
        return [okAction, cancelAction]
    }
    
    class func present(title: String, message: String, okTitle: String, cancelTitle: String, from presentingViewController: UIViewController? = nil, okAction: @escaping () -> Void, cancelAction: @escaping () -> Void) -> [UIAlertAction] {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let titleFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 18)! ]
        let messageFont:[NSAttributedString.Key : AnyObject] = [ NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 14)! ]
        
        let attributedTitle = NSMutableAttributedString(string: title, attributes: titleFont)
        let attributedMessage = NSMutableAttributedString(string: message, attributes: messageFont)
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { _ in okAction() } )
        okAction.setValue(UIColor.primaryColor(), forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in cancelAction() })
        cancelAction.setValue(UIColor.primaryColor(), forKey: "titleTextColor")
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        (presentingViewController ?? UIWindow.visibleViewController())?.present(alertController, animated: true, completion: nil)
        return [okAction, cancelAction]
    }
    
    // This has to be set after presenting the alert, otherwise the internal property __representer is nil
    class func configureActionLabel(okTitle: String, cancelTitle: String? = nil, actions: [UIAlertAction]) {
        let okattributedText = NSMutableAttributedString(string: okTitle)
        let noattributedText = NSMutableAttributedString(string: cancelTitle ?? "")
        let range = NSRange(location: 0, length: okattributedText.length)
        let cancelRannge = NSRange(location: 0, length: noattributedText.length)
        okattributedText.addAttribute(NSAttributedString.Key.kern, value: 1.5, range: range)
        okattributedText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Montserrat-Regular", size: 15.0)!, range: range)
        noattributedText.addAttribute(NSAttributedString.Key.kern, value: 1.5, range: cancelRannge)
        noattributedText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Montserrat-Regular", size: 15.0)!, range: cancelRannge)
        for (index, action) in actions.enumerated() {
            guard let representer = action.value(forKey: "__representer"), let label = (representer as AnyObject).value(forKey: "label") as? UILabel else { return }
            label.attributedText = index == 0 ? okattributedText : noattributedText
        }
    }
    
}

extension UIWindow {
    
    class func visibleViewController() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let window = appDelegate?.window
        if let rootViewController: UIViewController = window?.rootViewController {
            return UIWindow.getVisibleViewController(startingViewController: rootViewController)
        } else {
            return nil
        }
    }
    
    private class func getVisibleViewController(startingViewController: UIViewController) -> UIViewController? {
        if let navigationController = startingViewController as? UINavigationController {
            return navigationController.visibleViewController
        } else if let tabBarController = startingViewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return getVisibleViewController(startingViewController: selectedViewController)
            }
        } else if let presentedViewController = startingViewController.presentedViewController {
            return getVisibleViewController(startingViewController: presentedViewController)
        }
        return startingViewController
    }
    
}

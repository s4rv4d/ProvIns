//
//  SignUpViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var emailTextfield: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textfieldDelegateSetup()
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    //MARK: - Textfield delegate
    func textfieldDelegateSetup() {
        emailTextfield.delegate = self
        textfieldViewSetup()
    }
    
    func textfieldViewSetup(){
        //for username textfield
        emailTextfield.backgroundColor = UIColor.init(255.0, 255.0, 255.0, 1.0)
        emailTextfield.layoutIfNeeded()
        emailTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        emailTextfield.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedString.Key.foregroundColor:UIColor(51, 1, 54, 0.4)])
        emailTextfield.layer.cornerRadius = 12
        emailTextfield.layer.masksToBounds = false
        emailTextfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        emailTextfield.layer.shadowRadius = 3.0
        emailTextfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
        emailTextfield.layer.shadowOffset = CGSize(width: 0, height: 3)
        emailTextfield.layer.shadowOpacity = 1.0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

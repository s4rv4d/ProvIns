//
//  loginViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var provinceBtmHdrConst: NSLayoutConstraint!
    @IBOutlet weak var disView: NSLayoutConstraint!
    
    //view
    @IBOutlet weak var loginViewCard: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initalSetup()
    }
    
    //MARK: - Functions
    func initalSetup() {
        self.disView.constant = 30
        self.provinceBtmHdrConst.constant = 695.3
        loginViewCard.isHidden = true
        textfieldDelegateSetup()
        textfieldViewSetup()
        
    }
    
    //MARK: - IBActions
    @IBAction func getStartedTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 10) {
            self.provinceBtmHdrConst.constant = 560.3 //695.3
            self.disView.constant = 500 //30
            self.loginViewCard.isHidden = false
            self.viewDidLayoutSubviews()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func fgtPassTapped(_ sender: UIButton) {
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            fatalError("couldnt init vc")
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
}

extension loginViewController: UITextFieldDelegate {
    
    //MARK: - Textfield functions
    func textfieldDelegateSetup(){
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
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
        
        //password
        passwordTextfield.backgroundColor = UIColor.init(255.0, 255.0, 255.0, 1.0)
        passwordTextfield.layoutIfNeeded()
        passwordTextfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor:UIColor(51, 1, 54, 0.4)])
        passwordTextfield.layer.cornerRadius = 12
        passwordTextfield.layer.masksToBounds = false
        passwordTextfield.defaultTextAttributes.updateValue(2.0, forKey: NSAttributedString.Key.kern)
        passwordTextfield.layer.shadowRadius = 3.0
        passwordTextfield.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
        passwordTextfield.layer.shadowOffset = CGSize(width: 0, height: 3)
        passwordTextfield.layer.shadowOpacity = 1.0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

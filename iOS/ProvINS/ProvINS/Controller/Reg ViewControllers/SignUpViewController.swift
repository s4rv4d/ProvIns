//
//  SignUpViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import SwiftyJSON
import Lottie

class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var textfieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var buttonoutlet: UIButton!
    @IBOutlet weak var proHeader: UIImageView!
    @IBOutlet weak var aniView: UIView!
    
    
    //MARK: - Variables
    var flag:Int!
    let animationView = AnimationView()

    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uiUpdates()
        animationSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in
                            if finished {
                                print("Animation Complete")
                            } else {
                                print("Animation cancelled")
                            }
        })
    }
    
    //MARK: - Function
    func uiUpdates() {
        if flag == 0 {
            //sign up ui
            textfieldDelegateSetup()
            proHeader.isHidden = false
            topLabel.text = "Enter a valid email address that you can access."
            emailTextfield.isHidden = false
            textfieldTopConstraint.constant = 21
            buttonoutlet.setImage(UIImage(named: "signUpButton"), for: .normal)
        } else if flag == 1 {
            //login ui
            topLabel.text = "We’ve sent an email to \(self.emailTextfield.text!)"
            emailTextfield.isHidden = true
            proHeader.isHidden = false
            textfieldTopConstraint.constant = 0
            buttonoutlet.setImage(UIImage(named: "loginBtn"), for: .normal)
        } else if flag == 2 {
            topLabel.text = "We have sent you the temporary password on your email…"
            emailTextfield.isHidden = true
            proHeader.isHidden = false
            textfieldTopConstraint.constant = 0
            buttonoutlet.setImage(UIImage(named: "loginBtn"), for: .normal)
            self.sentEmail()
        }
    }
    
    func sentEmail() {
        //email resend pass logic
    }
    
    func animationSetup() {
        print("entered this function")
        let animationTest = Animation.named("data")
        print(animationTest)
        
        animationView.animation = animationTest
        animationView.contentMode = .scaleAspectFill
        aniView.addSubview(animationView)
        
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo: aniView.topAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: aniView.leadingAnchor).isActive = true
        
        animationView.bottomAnchor.constraint(equalTo: aniView.bottomAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: aniView.trailingAnchor).isActive = true
        animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
    }
    
    //MARK: - IBAction
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if flag == 0 {
            //check if text not empty
            if emailTextfield.text != "" {
                //signUp
                
                let params = ["email":emailTextfield.text!]
                let req = SignUpRequest(email: emailTextfield.text!)

                SignUpService().call(with: req).continueOnSuccessWith{ task in
                    if !task.isFaulted, let result = task.result {
                        var userResponse = UserResponse()
                        userResponse.__v = result.__v!
                        userResponse.email = result.email!
                        userResponse.password = result.password!
                        userResponse._id = result._id!
                        userResponse.devices = result.devices!

                        let user = User(email: userResponse.email, password: userResponse.password, devices: userResponse.devices)
                        user.save(userResponse: ["__v":userResponse.__v,
                                                 "email":userResponse.email,
                                                 "password":userResponse.password,
                                                 "_id":userResponse._id,
                                                 "devices":userResponse.devices])
                        
                        self.flag = 1
                        self.uiUpdates()
                    }
                    return task
                    }.continueWith { task in
                        if let error = task.error {
                            if InternetConnection.isNotAvailable(error: error) {
                                DispatchQueue.main.async {
//                                    self.ai.hide()
                                    self.flag = 0
                                    let _ = ProvinsAlertViewController.present(title: "Internet Lost", message: "Internet connection appears to be offline.", okTitle: "Dismiss", from: self, okAction: {
                                        self.proHeader.isHidden = true
                                        self.dismiss(animated: true, completion: nil)
                                    })
                                }
                            } else {
                                DispatchQueue.main.async {
//                                    self.ai.hide()
                                    let _ = ProvinsAlertViewController.present(title: "Signup Error", message: error.localizedDescription, okTitle: "Dismiss", from: self, okAction: {
                                        self.proHeader.isHidden = true
                                        self.dismiss(animated: true, completion: nil)
                                    })
                                    self.flag = 0
                                }
                            }
                        }
                        return task
                }
            }
        } else if flag == 1 || flag == 2 {
            //login UI Updates
            flag = 0
            self.proHeader.isHidden = true
            self.dismiss(animated: true, completion: nil)
            
        }
        
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

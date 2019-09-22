//
//  loginViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Lottie

class loginViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var provinceBtmHdrConst: NSLayoutConstraint!
    @IBOutlet weak var disView: NSLayoutConstraint!
    
    //view
    @IBOutlet weak var loginViewCard: UIView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var aniView: UIView!
    
    //MARK: - Variables
    let animationView = AnimationView()
    
    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initalSetup()
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
    
    //MARK: - Functions
    func initalSetup() {
        self.disView.constant = 30
        self.provinceBtmHdrConst.constant = 695.3
        loginViewCard.isHidden = true
        textfieldDelegateSetup()
        textfieldViewSetup()
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
    
    //MARK: - IBActions
    @IBAction func getStartedTapped(_ sender: UIButton) {
            self.provinceBtmHdrConst.constant = 560.3 //695.3
            self.disView.constant = 500 //30
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.loginViewCard.isHidden = false
        })
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        //always update the userdefaults
        if emailTextfield.text != "" && passwordTextfield.text != "" {
            let params = ["email":emailTextfield.text!,"password":passwordTextfield.text!]
            let req = LoginRequest(email: emailTextfield.text!, password: passwordTextfield.text!)
            
            LoginService().call(with: req).continueOnSuccessWith { task in
                
                if !task.isFaulted, let result = task.result {
                    let user = User(email: result.email!, password: result.password!, devices: result.devices!)
                    user.save(userResponse: [
                        "__v":result.__v!,
                        "email":result.email!,
                        "password":result.password!,
                        "_id":result._id!,
                        "devices":result.devices!
                        ])
                    
                    //go to main
                    guard let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                        fatalError("couldnt init vc")
                    }
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = mainView
                }
                return task
                }.continueWith { task in
                    if let error = task.error {
                        if InternetConnection.isNotAvailable(error: error) {
                            DispatchQueue.main.async {
                                //                                    self.ai.hide()
                                let _ = ProvinsAlertViewController.present(title: "Internet Lost", message: "Internet connection appears to be offline.", okTitle: "Dismiss", from: self, okAction: {
                                })
                            }
                        } else {
                            DispatchQueue.main.async {
                                //                                    self.ai.hide()
                                let _ = ProvinsAlertViewController.present(title: "Signup Error", message: error.localizedDescription, okTitle: "Dismiss", from: self, okAction: {
                                })
                            }
                        }
                    }
                    return task
            }
        }
        
    }
    
    @IBAction func fgtPassTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            fatalError("couldnt init vc")
        }
        vc.flag = 2
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            fatalError("couldnt init vc")
        }
        vc.flag = 0
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

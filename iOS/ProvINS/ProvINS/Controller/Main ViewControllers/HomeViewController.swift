//
//  HomeViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var aniView: UIView!
    @IBOutlet weak var addDevView: UIImageView!
    @IBOutlet weak var bluetoothView: UIImageView!
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var wifiView: UIImageView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var collectStack: UIStackView!
    @IBOutlet weak var addViewBig: UIView!
    
    //MARK: - Variables
    let animationView = AnimationView()

    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        animationSetup()
        initialSetup()
        tapGestures()
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
    func tapGestures() {
        let addDevViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
        let bluetooth = UITapGestureRecognizer(target: self, action: #selector(self.bluetoothTapped))
        let wifi = UITapGestureRecognizer(target: self, action: #selector(self.wifiTapped))
        let camera = UITapGestureRecognizer(target: self, action: #selector(self.scanTapped))
        
        addViewBig.isUserInteractionEnabled = true
        bluetoothView.isUserInteractionEnabled = true
        wifiView.isUserInteractionEnabled = true
        cameraView.isUserInteractionEnabled = true
        
        addViewBig.addGestureRecognizer(addDevViewTapGesture)
        bluetoothView.addGestureRecognizer(bluetooth)
        wifiView.addGestureRecognizer(wifi)
        cameraView.addGestureRecognizer(camera)
    }
    func initialSetup() {
        self.heightConst.constant = 51 //114
        collectStack.isHidden = true
        addViewBig.layer.cornerRadius = 27
        addViewBig.layer.masksToBounds = false
        
        addViewBig.layer.shadowRadius = 3.0
        addViewBig.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
        addViewBig.layer.shadowOffset = CGSize(width: 0, height: 3)
        addViewBig.layer.shadowOpacity = 1.0
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
    
    @objc func viewTapped() {
        if self.heightConst.constant == 51 {
            self.heightConst.constant = 114
            collectStack.isHidden = false
            addViewBig.layer.cornerRadius = 27
            addViewBig.layer.masksToBounds = false
            
            addViewBig.layer.shadowRadius = 3.0
            addViewBig.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
            addViewBig.layer.shadowOffset = CGSize(width: 0, height: 3)
            addViewBig.layer.shadowOpacity = 1.0
        } else {
            self.heightConst.constant = 51 //114
            collectStack.isHidden = true
            addViewBig.layer.cornerRadius = 27
            addViewBig.layer.masksToBounds = false
            
            addViewBig.layer.shadowRadius = 3.0
            addViewBig.layer.shadowColor = UIColor.init(0, 0, 0, 0.16).cgColor
            addViewBig.layer.shadowOffset = CGSize(width: 0, height: 3)
            addViewBig.layer.shadowOpacity = 1.0
        }
        
    }
    
    @objc func bluetoothTapped() {
        print("bluetooth tapped")
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "BluetoothViewController") as? BluetoothViewController else {
            fatalError("couldnt init")
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func wifiTapped() {
        print("wifi tapped")
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "WifiViewController") as? WifiViewController else {
            fatalError("couldnt init")
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func scanTapped() {
        print("camera tapped")
        
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController else {
            fatalError("couldnt init")
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}

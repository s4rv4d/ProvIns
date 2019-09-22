//
//  testlottieViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Lottie

class testlottieViewController: UIViewController {

    @IBOutlet weak var aniView: UIView!
    
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func animationSetup() {
        print("entered this function")
        let animationTest = Animation.named("Assembly_2")
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

}

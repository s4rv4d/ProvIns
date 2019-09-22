//
//  AppDelegate.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if UserDefaults.standard.object(forKey: userObj) != nil {
            //logged in
            self.GoToMain()
        } else {
            //not logged in
            self.GoToReg()
        }
        
        return true
    }

    func GoToMain(){
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.window?.rootViewController = mainView
    }
    
    func GoToReg(){
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        self.window?.rootViewController = mainView
    }

}


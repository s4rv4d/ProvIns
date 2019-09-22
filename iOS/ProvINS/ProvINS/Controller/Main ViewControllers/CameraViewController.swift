//
//  CameraViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var deviceType:String! = ""

protocol hi {
    func dataName(name:String)
}

class CameraViewController: UIViewController, hi {
    
    @IBOutlet weak var deviceName: UILabel!
    
    
    var deviceType:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        deviceName.text = deviceType
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "testCoreMLViewController") as? testCoreMLViewController else {
            fatalError("couldnt init")
        }
        vc.delegate = self
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func bckTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func dataName(name: String) {
        deviceName.text = name
        
        let obj =  UserDefaults.standard.object(forKey: userObj) as! [String:Any]
        print(obj["devices"] as! Array<CardModel>)
        print(obj)
        //add device
        let params = ["email":obj["email"] as! String,"devName":"","devType":name ,"ip":"","mac":"","blueName":""]
        
        let url = URL(string: "https://provins.herokuapp.com/add")
        Alamofire.request(url!, method: .post, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let responseJSON):
                let res = JSON(responseJSON)
                print("here: \(res)")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

}

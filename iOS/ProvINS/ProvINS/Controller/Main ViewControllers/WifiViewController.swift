//
//  WifiViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import MMLanScan
import SwiftyJSON
import Alamofire

class WifiViewController: UIViewController, MMLANScannerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var lanScanner : MMLANScanner!
    var arr:[Device]!
    
    
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lanScanner = MMLANScanner(delegate:self)
        self.lanScanner.start()
        arr = [Device]()
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        print("device brand: \(device.brand)")
        print("device ip: \(device.ipAddress)")
        print("device host: \(device.hostname)")
        print("device mac: \(device.macAddress)")
        print("device is local: \(device.isLocalDevice)")
        print("/////////////////////////////////")
        if device.macAddress != nil {
            let obj = Device(mac: device.macAddress, ip: device.ipAddress)
            arr.append(obj)
        }
        
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        print(status.rawValue)
        
        print(arr)
        tbView.reloadData()
    }
    
    func lanScanDidFailedToScan() {
        print("not able to scan")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WifiTableViewCell else {
            fatalError("fddf")
        }
        cell.macAddress.text = "Mac Address: \(arr![indexPath.row].mac)"
        cell.ipAddress.text = "Ip address: \(arr![indexPath.row].ip)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objNew = arr[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let obj =  UserDefaults.standard.object(forKey: userObj) as! [String:Any]
        print(obj["devices"] as! Array<CardModel>)
        print(obj)
        //add device
        let params = ["email":obj["email"] as! String,"devName":"","devType":name ,"ip":objNew.ip,"mac":objNew.mac,"blueName":""]
        
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



struct Device {
    var mac:String
    var ip:String
}

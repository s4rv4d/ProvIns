//
//  BluetoothViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/22/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyJSON
import Alamofire

class BluetoothViewController: UIViewController, CBCentralManagerDelegate {
    
    var peripherals:[CBPeripheral] = []
    var manager: CBCentralManager? = nil
    let BLEService = "DFB0"
    let BLECharacteristic = "DFB1"
    var gameTimer: Timer?
    var containsArray:[CBPeripheral]!
    var bltName:[String]!
    
    
    @IBOutlet weak var bluTbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bltName = [String]()
        containsArray = [CBPeripheral]()
        
        manager = CBCentralManager(delegate: self, queue: nil);
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.stopScanForBLEDevice()
        }
        manager?.scanForPeripherals(withServices: [CBUUID.init(string:BLEService)], options: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
            manager!.stopScan()
        case .poweredOn:
            print("poweredOn")
            manager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //array should be reset initialy
        
        if RSSI.intValue >= -70 && RSSI.intValue <= -30 {
            
            if !(containsArray.contains(peripheral)) {
                containsArray.append(peripheral)
                
                if peripheral.name != nil {
                    bltName.append(peripheral.name!)
                }
            }
        }
    }
    
    func stopScanForBLEDevice(){
        manager?.stopScan()
        print("scan stopped")
        print(bltName)
        
        //reload table view
        self.bluTbView.reloadData()
        
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension BluetoothViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bltName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = bluTbView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BluetoothTableViewCell else {
            fatalError("jdakjda")
        }
        cell.deviceName.text = "Device \(indexPath.row + 1): \(bltName[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objNew = bltName[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let obj =  UserDefaults.standard.object(forKey: userObj) as! [String:Any]
        print(obj["devices"] as! Array<CardModel>)
        print(obj)
        //add device
        let params = ["email":obj["email"] as! String,"devName":"","devType":"" ,"ip":"","mac":"","blueName":objNew]
        
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

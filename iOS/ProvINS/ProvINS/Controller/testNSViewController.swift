//
//  testNSViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import MMLanScan
import CoreBluetooth

class testNSViewController: UIViewController, MMLANScannerDelegate,CBCentralManagerDelegate {
    
    var lanScanner : MMLANScanner!
    var peripherals:[CBPeripheral] = []
    var manager: CBCentralManager? = nil
    let BLEService = "DFB0"
    let BLECharacteristic = "DFB1"
    var gameTimer: Timer?
    var containsArray:[CBPeripheral]!
    var bltName:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("entered here")
        self.lanScanner = MMLANScanner(delegate:self)
        self.lanScanner.start()
        containsArray = [CBPeripheral]()
        bltName = [String]()
//        manager = CBCentralManager(delegate: self, queue: nil);
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.stopScanForBLEDevice()
//        }
//        manager?.scanForPeripherals(withServices: [CBUUID.init(string:BLEService)], options: nil)
    }
    
    func lanScanDidFindNewDevice(_ device: MMDevice!) {
        print("device brand: \(device.brand)")
        print("device ip: \(device.ipAddress)")
        print("device host: \(device.hostname)")
        print("device mac: \(device.macAddress)")
        print("device is local: \(device.isLocalDevice)")
        print("/////////////////////////////////")
    }
    
    func lanScanDidFinishScanning(with status: MMLanScannerStatus) {
        print(status.rawValue)
    }
    
    func lanScanDidFailedToScan() {
        print("not able to scan")
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
        
    }
}

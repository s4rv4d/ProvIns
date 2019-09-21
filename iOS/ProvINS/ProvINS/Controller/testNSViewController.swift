//
//  testNSViewController.swift
//  ProvINS
//
//  Created by Sarvad shetty on 9/21/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit
import MMLanScan

class testNSViewController: UIViewController, MMLANScannerDelegate {
    
    var lanScanner : MMLANScanner!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("entered here")
        self.lanScanner = MMLANScanner(delegate:self)
        self.lanScanner.start()
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

}

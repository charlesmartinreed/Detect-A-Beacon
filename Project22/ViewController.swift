//
//  ViewController.swift
//  Project22
//
//  Created by Charles Martin Reed on 8/24/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //based upon location of iBeacon, we'll update this label to say "Unknown", "Far", "Near" or "Right here"
    @IBOutlet weak var distanceReading: UILabel!
    
    //PROPERTIES
    //this class lets us configure how we wanted to be notified about location and deliver them to us
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //keep the user's location, even when not in use
        locationManager.requestWhenInUseAuthorization()
        
        //we'll also be using color to show the user how close to the beacon they are
        view.backgroundColor = UIColor.gray
        
    }
    
    //CLBeaconRegion is passed to our location manager in order to start identifiying beacons, uniquely.
    //Beacons have a UUID and a major number used to subdivide that UUID and a minor number used to subdivide that. Think of UUID as Macys, Major as the Times Square Macys and Minor as the 5th floor, women's clothing of that store.
    //we use .startMonitoring and startRangingBeacons to trigger the search
    
    func startScanning() {
        //this UUID string is used by the Locate Beacon app
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        //these are specific numbers given by Paul in creation of this exercise
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //did we get authorization? then, is our device capable of monitoring iBeacons? then, is it able to tell how far away the next iBeacon is? If so, do the damn thang.
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    //there are only four distance values for us to switch on, provided to us by Apple
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            [unowned self] in
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT"
            }
        }
    }
    
    //once we've ranged, we'll have to check the results and use it for our update function
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //if we found any beacons at all
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }



}


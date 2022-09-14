//
//  ViewController.swift
//  Project22
//
//  Created by DongKyu Kim on 2022/09/14.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var distanceReadingPhone: UILabel!
    
    // 어떻게 location에 대해 알림을 받을지 configure
    var locationManager: CLLocationManager?
    
    var alertShown = false
    
    let iPaduuid = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6")!
    let iPhoneuuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
    
    var beaconDict: [UUID: [CLBeacon]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceReading.layer.masksToBounds = true
        distanceReading.adjustsFontSizeToFitWidth = true
        distanceReading.layer.cornerRadius = 114
        //distanceReadingPhone.layer.cornerRadius = 128
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization() // 위치 허가를 받으면 수행

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // 사용자 권한 체크 이후 행동
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            if CLLocationManager.isRangingAvailable() {
                startScanning()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("beacon: \(beacons)")
        print("beacon Region: \(region.uuid)")
        
        beaconDict[region.uuid] = beacons
        
        // Beacon Detection
        switch region.uuid {
        case iPaduuid:
            showAlert()
            if let beacon = beaconDict[region.uuid]?.first {
                update(distance: beacon.proximity, type: "iPad")
            } else {
                update(distance: .unknown, type: "iPad")
            }
        case iPhoneuuid:
            showAlert()
            if let beacon = beaconDict[region.uuid]?.first {
                update(distance: beacon.proximity, type: "iPhone")
            } else {
                update(distance: .unknown, type: "iPhone")
            }
        default:
            print("No beacon detected")
            break
        }
    }
    
    func startScanning() {
        // iPad Beacon
        let beaconRegion = CLBeaconRegion(uuid: iPaduuid, major: 123, minor: 456, identifier: "MyBeaconiPad")
        let beaconSatisfying = CLBeaconIdentityConstraint(uuid: iPaduuid, major: 123, minor: 456)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconSatisfying)
        
        // iPhone Beacon
        let beaconRegion2 = CLBeaconRegion(uuid: iPhoneuuid, major: 456, minor: 789, identifier: "MyBeaconiPhone")
        let beaconSatisfying2 = CLBeaconIdentityConstraint(uuid: iPhoneuuid, major: 456, minor: 789)

        locationManager?.startMonitoring(for: beaconRegion2)
        locationManager?.startRangingBeacons(satisfying: beaconSatisfying2)
    }
    
    func update(distance: CLProximity, type: String) {
        if  type == "iPad" {
            UIView.animate(withDuration: 0.8) {
                switch distance {
                case .far:
                    self.distanceReading.backgroundColor = UIColor.blue
                    self.distanceReading.text = "iPad FAR"

                case .near:
                    self.distanceReading.backgroundColor = UIColor.orange
                    self.distanceReading.text = "iPad NEAR"
                    
                case .immediate:
                    self.distanceReading.backgroundColor = UIColor.red
                    self.distanceReading.text = "iPad RIGHT HEAR"

                default:
                    self.distanceReading.backgroundColor = UIColor.gray
                    self.distanceReading.text = "iPad UNKNOWN"
                }
            }
        } else if type == "iPhone" {
            UIView.animate(withDuration: 0.8) {
                switch distance {
                case .far:
                    self.distanceReadingPhone.backgroundColor = UIColor.blue
                    self.distanceReadingPhone.text = "iPhone FAR"

                case .near:
                    self.distanceReadingPhone.backgroundColor = UIColor.orange
                    self.distanceReadingPhone.text = "iPhone NEAR"
                    
                case .immediate:
                    self.distanceReadingPhone.backgroundColor = UIColor.red
                    self.distanceReadingPhone.text = "iPhone RIGHT HEAR"

                default:
                    self.distanceReadingPhone.backgroundColor = UIColor.gray
                    self.distanceReadingPhone.text = "iPhone UNKNOWN"
                }
            }
        }

    }
    
    func showAlert() {
        if alertShown {
            let ac = UIAlertController(title: "Detected Beacon!", message: "Beacon is detected. Check your position now.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}


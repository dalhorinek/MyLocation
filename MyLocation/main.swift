//
//  main.swift
//  MyLocation
//
//  Created by Dalibor Horinek on 03/09/2016.
//  Copyright © 2016 Dalibor Horinek. All rights reserved.
//

import Foundation
import CoreLocation

class MyLocation: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        
        if status != .authorizedAlways {
            exit(3)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let location: CLLocation = locations[0]
            let coordinate = location.coordinate
            print("\(coordinate.latitude) \(coordinate.longitude)")
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                let possibleAddress: CLPlacemark? = placemarks?.first
                
                if let address = possibleAddress {
                    print("\(address.name!) \(address.administrativeArea!) \(address.country!)")
                    exit(0)
                }
            })
        }
    }
    
    func start() {
        let authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == CLAuthorizationStatus.restricted || authStatus == CLAuthorizationStatus.denied {
            print("Sorry, location is not permited, you need to enable it in System Preferences")
            exit(1)
        }
        
        if CLLocationManager.locationServicesEnabled() != true {
            print("Sorry, location not supported")
            exit(2)
        }
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
}

let ml = MyLocation()
ml.start()

autoreleasepool({
    var runLoop: RunLoop = RunLoop.main()
    runLoop.run()
})

//
//  LocationObserver.swift
//  LocationObserverTest
//
//  Created by Daisuke TONOSAKI on 2019/10/14.
//  Copyright © 2019 Daisuke TONOSAKI. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationObserver: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published private(set) var location = CLLocation()
  
  private let locationManager: CLLocationManager
  
  override init() {
    self.locationManager = CLLocationManager()
    
    super.init()
    
    self.locationManager.delegate = self
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    self.locationManager.requestAlwaysAuthorization()
    self.locationManager.startUpdatingLocation()
  }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        location = locations.last!
        
        print(location.coordinate)
    }
//  func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]) {
//    location = didUpdateLocations.last!
//
//    print(location.coordinate)
//  }
  
}

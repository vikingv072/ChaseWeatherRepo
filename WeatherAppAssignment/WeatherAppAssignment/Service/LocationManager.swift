//
//  LocationManager.swift
//  WeatherProject
//
//  Created by Kevin Varghese on 5/31/23.
//

import Foundation
import CoreLocation

protocol LocationManagerProtocol {
    func locationFail()
    func locationUpdate(lat: Double, lon: Double)
}

protocol LocationManagerService {
    var delegate: LocationManagerProtocol? { set get }
    func locationRetrieve()
}

class LocationManager: NSObject, LocationManagerService, CLLocationManagerDelegate {
    var delegate: LocationManagerProtocol?
    let cllManager = CLLocationManager()
    
    override init() {
        super.init()
        locationRetrieve()
    }
    
    func locationRetrieve() {
        cllManager.delegate = self
        cllManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.delegate?.locationUpdate(lat: location.coordinate.latitude,
                                          lon: location.coordinate.longitude)
        } else {
            self.delegate?.locationFail()
        }
    }
    
    // setting Auth status
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch cllManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.cllManager.requestLocation()
        default:
            self.delegate?.locationFail()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationFail()
        print(error.localizedDescription)
    }
    
}

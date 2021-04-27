//
//  File.swift
//  
//
//  Created by Kevin McQuown on 4/27/21.
//
import Foundation
import CoreLocation

public class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    public var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    public func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}

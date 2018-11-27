//
//  ViewController.swift
//  FetchToGoogleMap
//
//  Created by Preuttipan Janpen on 27/11/2561 BE.
//  Copyright © 2561 Lphant. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var textFieldProvince: UITextField!
    let marker = GMSMarker()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
       
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.isMyLocationEnabled = false
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker.map = mapView
        
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.map = mapView
        
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func getCoordinate(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    print("Location not found.")
                    return
            }
            
            self.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.marker.map = self.mapView
        }
    }
    
    @IBAction func onClickGetCoordinate(_ sender: Any) {
        getCoordinate(address: textFieldProvince.text!)
    }
}


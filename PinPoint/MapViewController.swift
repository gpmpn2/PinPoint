//
//  MapViewController.swift
//  PinPoint
//
//  Created by Grant Maloney on 8/28/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import CoreLocation
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Profile"), style: .plain, target: self, action: #selector(self.viewProfile))
        
        self.navigationController?.isToolbarHidden = false
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        var items = [UIBarButtonItem]()
        items.append(space)
        items.append(UIBarButtonItem(image: UIImage(named: "Post"), style: .plain, target: self, action: #selector(self.viewPost)))
        items.append(space)
        items.append(UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(self.viewProfile)))
        items.append(space)
        
        self.toolbarItems = items
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true;
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        viewPost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    @objc
    func viewProfile() {
        self.performSegue(withIdentifier: "showProfileView", sender: nil)
    }

    @objc
    func viewPost() {
        print("VIEWING POST")
        let locationPoint = Location(city: "San Francisco", state: "CA", business: 738999)
        locationPoint.getData() { hotSpots in
            print(hotSpots)
            for hotSpot in hotSpots {
                
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(hotSpot.address) { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                        else { return }
                    
                    print("Making annotation for \(hotSpot.name) \(hotSpot.address)")
                    let annotation = MKPointAnnotation()
                    annotation.title = hotSpot.name
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    //This utilizes pins
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MKPointAnnotation else { return nil }
//
//        let identifier = "Annotation"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView!.canShowCallout = true
//        } else {
//            annotationView!.annotation = annotation
//        }
//
//        return annotationView
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

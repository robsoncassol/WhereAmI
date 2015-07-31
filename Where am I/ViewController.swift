//
//  ViewController.swift
//  Map Demo
//
//  Created by Robson Cassol on 27/07/15.
//  Copyright (c) 2015 cassol. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var latitudeLabe: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        var latitude:CLLocationDegrees = 43.095181
        var longitude:CLLocationDegrees = -79.006424
        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        updateLocation(location)
        
        createAnAnnotation(location, title:"I want to go here", subTitle:"one day will go here")
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 1
        
        map.addGestureRecognizer(uilpgr)
    }
    
    func updateLocation(location:CLLocationCoordinate2D){
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region , animated: true)
    }
    
    func createAnAnnotation(location:CLLocationCoordinate2D, title:String, subTitle:String){
        
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        
        annotation.title = "Niagra falls"
        
        annotation.subtitle = "One day I`ll go here..."
        
        map.addAnnotation(annotation)

        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println(locations.description)
        
        var userLocation: CLLocation = locations[0] as! CLLocation
        
        updateLocation(userLocation.coordinate)
        
        createAnAnnotation(userLocation.coordinate, title: "Oo", subTitle: "subtitle")
        
        
        latitudeLabe.text = userLocation.coordinate.latitude.description
        longitudeLabel.text = userLocation.coordinate.longitude.description
        courseLabel.text = userLocation.course.description
        altitudeLabel.text = userLocation.altitude.description
        speedLabel.text = userLocation.speed.description
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                println(error)
            } else {
                
                if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark) {
                    
                    var subThoroughfare:String = ""
                    
                    if p.subThoroughfare != nil {
                        subThoroughfare = p.subThoroughfare
                    }
                    
                    self.addressLabel.text = "\(subThoroughfare) \n \(p.thoroughfare) \n \(p.subLocality) \n \(p.subAdministrativeArea) \n \(p.postalCode) \n \(p.country)"
                    
                }
                
            }
            
            
            
            
        })


    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        
        println("gesto reconhecido")
        
        var touchPoint = gestureRecognizer.locationInView(self.map)
        
        var newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map);
        
        
        var annotation = MKPointAnnotation()
        
        annotation.coordinate = newCoordinate
        
        annotation.title = "New Place"
        
        annotation.subtitle = "One day I`ll go here..."
        
        map.addAnnotation(annotation)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


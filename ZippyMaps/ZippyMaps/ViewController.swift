//
//  ViewController.swift
//  ZippyMaps
//
//  Created by Kay,Maxwell on 11/15/16.
//  Copyright © 2016 Kay,Maxwell. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapSwipeGesture: UISwipeGestureRecognizer!
    
    //UA's GPS coords 41.075931, -81.511134
    @IBOutlet weak var AkronMap: MKMapView!
    var classRoute: MKRoute!
    var locations: CLLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AkronMap.delegate = self
        
        //CLLocation is required to track the user
        locations.delegate = self
        locations.requestWhenInUseAuthorization()
        
        let defaultLocation = CLLocationCoordinate2D(latitude: 41.075931, longitude: -81.511134)
        //Set the map to the hybrid display
        AkronMap.mapType = MKMapType.hybrid
        //Show user location
        AkronMap.showsUserLocation = true
        
        //Area in meters
        let areaRegion: CLLocationDistance = 500
        let defaultRegion = MKCoordinateRegionMakeWithDistance(defaultLocation, areaRegion, areaRegion)
        AkronMap.setRegion(defaultRegion, animated: false)
        //print("HERE")
        //print(AkronMap.region)
        AkronMap.mapType = MKMapType.hybrid
        //AkronMap.delegate = self
        populateBuildings()
        print("IN PRIMARY VIEW CONTROLLER")
        examplePath()
        
        
        //Get user location:
        let currentUserLocation = AkronMap.userLocation.coordinate
        print("User at: \(currentUserLocation.latitude), \(currentUserLocation.longitude)")
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func populateBuildings(){
        //Zook Hall 41.076430, -81.511526
        //CAS 41.077726, -81.510762
        //Leigh Hall 41.077726, -81.510762
        //Bierce Library 41.076758, -81.510640
        
        let building1 = MKPointAnnotation()
        building1.coordinate = CLLocationCoordinate2D(latitude: 41.076430, longitude: -81.511526)
        building1.title = "Zook Hall"
        
        AkronMap.addAnnotation(building1)
        
        
    }
    
    func examplePath(){
        //Zook Hall
        let gpsLocationStart: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.076430, longitude: -81.511526)
        let startPlacemark: MKPlacemark = MKPlacemark(coordinate: gpsLocationStart)
        let startLocation: MKMapItem = MKMapItem(placemark: startPlacemark)
        
        //Bierce
        let gpsLocationEnd: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.076758, longitude: -81.510640)
        
        //White house
        //38.897685, -77.036530
        //let gpsLocationEnd: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 38.897685, longitude: -77.036530)
        let endPlacemark: MKPlacemark = MKPlacemark(coordinate: gpsLocationEnd)
        let endLocation: MKMapItem = MKMapItem(placemark: endPlacemark)
        
        
        let directionsRequest: MKDirectionsRequest = MKDirectionsRequest()
        directionsRequest.source = startLocation
        directionsRequest.destination = endLocation
        directionsRequest.transportType = MKDirectionsTransportType.walking
        //directionsRequest.transportType = MKDirectionsTransportType.automobile
        
        let directions: MKDirections = MKDirections(request: directionsRequest)
        directions.calculate(completionHandler: {
            response, error in
            
            if error == nil {
                print("VALID ROUTE")
                let validRoute: MKRoute = response!.routes[0]
                //self.AkronMap.add(validRoute.polyline, level: MKOverlayLevel.aboveRoads)
                self.classRoute = validRoute
                self.AkronMap.add(self.classRoute.polyline, level: MKOverlayLevel.aboveRoads)
                //self.AkronMap.addOverlays(validRoute.polyline.)
                //let rect = validRoute.polyline.boundingMapRect
                //self.AkronMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                print(validRoute.distance)
                
            }else{
                print("INVALID ROUTE")
            }
        
        })
        
        
        
    }
    //Need to actually draw the line.
    //Requires view Controller to be a delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let drawLine = MKPolylineRenderer(polyline: self.classRoute.polyline)
        drawLine.strokeColor = UIColor.red
        drawLine.lineWidth = 3
        return drawLine
    }
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print("Cannot locate the user: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("UPDATE")
        let userCoordinate: CLLocationCoordinate2D = userLocation.coordinate
        print("Location: Latitude: \(userCoordinate.latitude) Longitude: \(userCoordinate.longitude)")
    }
    
    //CLLocation Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Todo
        for location in locations {
            print("location. Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)")
        }
    }
    

}


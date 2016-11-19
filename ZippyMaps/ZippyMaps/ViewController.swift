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
        locations.delegate = self
        
        //Check if we have location permissions
        let locationAuthorization = CLLocationManager.authorizationStatus()
        if(locationAuthorization == CLAuthorizationStatus.denied){
            print("Location authorization error")
        }
        
        if(CLLocationManager.headingAvailable()){
            print("Heading available")
        }else{
            print("Heading not available")
        }
        
        
        
        //CLLocation is required to track the user
        //locations.desiredAccuracy
        locations.requestWhenInUseAuthorization()
        //locations.requestLocation()
        locations.startUpdatingLocation()
        locations.startUpdatingHeading()
        
        
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


        
        let human = CLLocationCoordinate2D(latitude: 41.076041, longitude: -80.511550)
        let building = CLLocationCoordinate2D(latitude: 41.076041, longitude: -81.511142)
        let bearing = angle(human, building)
        print("Head: \(bearingString(bearing))")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func bearingString(_ bearing: Double) -> String{
        if ((bearing >= 0) && (bearing < 22.5)){
            return "North"
        }else if((bearing >= 22.5) && (bearing < 67.5)){
            return "Northwest"
        }else if((bearing >= 67.5) && (bearing < 112.5)){
            return "West"
        }else if((bearing >= 112.5) && (bearing < 157.5)){
            return "Southwest"
        }else if((bearing >= 157.5) && (bearing < 202.5)){
            return "South"
        }else if((bearing >= 202.5) && (bearing < 247.5)){
            return "Southeast"
        }else if((bearing >= 247.5) && (bearing < 292.5)){
            return "East"
        }else if((bearing >= 292.5) && (bearing < 337.5)){
            return "Northeast"
        }else if((bearing >= 337.5) && (bearing > 360)){
            return "North"
        }else{
            //<0 or >360
            return "Direction error"
        }
        
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
        let gpsLocationStart: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.077084, longitude: -81.51142)
        let startPlacemark: MKPlacemark = MKPlacemark(coordinate: gpsLocationStart)
        let startLocation: MKMapItem = MKMapItem(placemark: startPlacemark)
        
        //Bierce
        let gpsLocationEnd: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.511142, longitude: -81.51142)
        
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
    
    func degreesToRadians(_ degrees: Double) -> Double{
        return (M_PI * degrees)/180.0
    }
    
    func radiansToDegrees(_ radians: Double) -> Double{
        return (radians*180.0)/M_PI
    }
    
    func angle(_ position: CLLocationCoordinate2D, _ end: CLLocationCoordinate2D) -> Double {
        
        /*
        let latitude_radians_1:Double = degreesToRadians(position.latitude)
        //print(latitude_radians_1)
        let longitude_radians_1:Double = degreesToRadians(position.longitude)
        //print(longitude_radians_1)
        let latitude_radians_2:Double = degreesToRadians(end.latitude)
        //print(latitude_radians_2)
        let longitude_radians_2:Double = degreesToRadians(end.longitude)
        //print(longitude_radians_2)
        
        let delta_longitude = longitude_radians_2 - longitude_radians_1
        
        let x = cos(latitude_radians_2)*sin(delta_longitude)
        let y = cos(latitude_radians_1)*sin(latitude_radians_2) - cos(latitude_radians_2)*cos(delta_longitude)
        
        let bearingRadians: Double = atan2(x, y)
        
        var bearingDegrees = radiansToDegress(bearingRadians)
        if(bearingDegrees < 0.0){
            bearingDegrees = bearingDegrees + 360.0
        }
        return bearingDegrees
        */
        let fLat = degreesToRadians(position.latitude)
        let fLng = degreesToRadians(position.longitude)
        let tLat = degreesToRadians(end.latitude)
        let tLng = degreesToRadians(end.longitude)
        
        let a = Double(sin(fLng-tLng)*cos(tLat));
        let b = Double(cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(fLng-tLng))
        
        
        var bearingDegrees = radiansToDegrees(atan2(a,b))
        if (bearingDegrees < 0){
            bearingDegrees = bearingDegrees + 360.0
        }
        return bearingDegrees
        
        
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
        return
    }
    
    //CLLocation Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Todo
        /*
        for location in locations {
            print("location. Latitude: \(location.coordinate.latitude) Longitude: \(location.coordinate.longitude)")
        }
        */
        print("didUpdateLocations")
        return
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //Heading will not work do lack of compass simulation
        print("Heading update")
        
    }

}


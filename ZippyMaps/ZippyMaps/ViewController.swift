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
        
        //build plist
        buildPList();
        
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
        // read from plist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = URL(fileURLWithPath: paths[0]).appendingPathComponent("buildings.plist")
        
        guard let buildingData = NSArray(contentsOf: url) else {
            print("ERROR: reading plist from \(url)")
            return
        }
        for building in buildingData {
            let temp = building as! NSDictionary
        
            let tempBuilding = MKPointAnnotation()
            tempBuilding.coordinate = CLLocationCoordinate2D(latitude: temp["Latitude"] as! Double, longitude: temp["Longitude"] as! Double)
            tempBuilding.title = (temp["Name"] as! String)
            
            AkronMap.addAnnotation(tempBuilding)
        }
        
        
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
    
    func buildPList() {
        
        var newBuilding: [NSDictionary] = []
        
        var building: NSDictionary = [ "Name" : "Guzzetta Hall", "Latitude" : 41.077726, "Longitude" : -81.514078]
        newBuilding.append(building)
        building = [ "Name" : "CAS", "Latitude" : 41.077640, "Longitude" : -81.510562]
        newBuilding.append(building)
        building = [ "Name" : "APTC", "Latitude" : 41.080874, "Longitude" : -81.511260]
        newBuilding.append(building)
        building = [ "Name" : "ASEC", "Latitude" : 41.076141, "Longitude" : -81.514099]
        newBuilding.append(building)
        building = [ "Name" : "Ayer Hall", "Latitude" : 41.076276, "Longitude" : -81.513018]
        newBuilding.append(building)
        building = [ "Name" : "Bierce Library", "Latitude" : 41.076963, "Longitude" : -81.510136]
        newBuilding.append(building)
        building = [ "Name" : "Buchtel Hall", "Latitude" : 41.075925, "Longitude" : -81.511142]
        newBuilding.append(building)
        building = [ "Name" : "BCCE", "Latitude" : 41.077267, "Longitude" : -81.516685]
        newBuilding.append(building)
        building = [ "Name" : "CBA", "Latitude" : 41.077587, "Longitude" : -81.517660]
        newBuilding.append(building)
        building = [ "Name" : "Computer Center", "Latitude" : 41.075733, "Longitude" : -81.515508]
        newBuilding.append(building)
        building = [ "Name" : "Crouse Hall", "Latitude" : 41.076356, "Longitude" : -81.512191]
        newBuilding.append(building)
        building = [ "Name" : "MGH", "Latitude" : 41.075637, "Longitude" : -81.515000]
        newBuilding.append(building)
        building = [ "Name" : "Leigh Hall", "Latitude" : 41.076197, "Longitude" : -81.510697]
        newBuilding.append(building)
        building = [ "Name" : "Kolbe Hall", "Latitude" : 41.076324, "Longitude" : -81.509987]
        newBuilding.append(building)
        building = [ "Name" : "LAW", "Latitude" : 41.077328, "Longitude" : -81.515621]
        newBuilding.append(building)
        building = [ "Name" : "Olin Hall", "Latitude" : 41.077029, "Longitude" : -81.508754]
        newBuilding.append(building)
        building = [ "Name" : "JAR", "Latitude" : 41.075905, "Longitude" : -81.508711]
        newBuilding.append(building)
        building = [ "Name" : "SHN", "Latitude" : 41.075023, "Longitude" : -81.513636]
        newBuilding.append(building)
        building = [ "Name" : "SHS", "Latitude" : 41.074433, "Longitude" : -81.513979]
        newBuilding.append(building)
        building = [ "Name" : "Simmons Hall", "Latitude" : 41.078574, "Longitude" : -81.511747]
        newBuilding.append(building)
        building = [ "Name" : "Student Union", "Latitude" : 41.075630, "Longitude" : -81.512370]
        newBuilding.append(building)
        building = [ "Name" : "West Hall", "Latitude" : 41.076956, "Longitude" : -81.515846]
        newBuilding.append(building)
        building = [ "Name" : "Whitby Hall", "Latitude" : 41.076172, "Longitude" : -81.514558]
        newBuilding.append(building)
        building = [ "Name" : "Zook Hall", "Latitude" : 41.076204, "Longitude" : -81.511597]
        newBuilding.append(building)
        
        // write plist as local document
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = URL(fileURLWithPath: paths[0]).appendingPathComponent("buildings.plist")
        print(paths[0])
        
        DispatchQueue(label:"edu.uakron.cs.ios.tryplist").async {
            let testArray = newBuilding as NSArray
            if !testArray.write(to: url, atomically: true) {
                print("Error writing plist to \(url)")
            }
        }
        
    }
    

}


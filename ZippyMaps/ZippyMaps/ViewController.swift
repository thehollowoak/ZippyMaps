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
    var counter = 1
    
    var newBuilding: [NSDictionary] = []
    var targetBuilding: NSDictionary = [:]
    var buildings: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AkronMap.delegate = self
        locations.delegate = self
        
        //Check if we have location permissions
        let locationAuthorization = CLLocationManager.authorizationStatus()
        if(locationAuthorization == CLAuthorizationStatus.denied){
            print("Location authorization error")
        }
        //build plist
        //buildPList();
        
        if(CLLocationManager.headingAvailable()){
            print("Heading available")
        }else{
            print("Heading not available")
        }
        
        //var testTimer: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.testTimerFunc), userInfo: nil, repeats: true)
        
        
        populateBuildings()
        
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
        let areaRegion: CLLocationDistance = 1000
        let defaultRegion = MKCoordinateRegionMakeWithDistance(defaultLocation, areaRegion, areaRegion)
        AkronMap.setRegion(defaultRegion, animated: false)
        //print("HERE")
        //print(AkronMap.region)
        AkronMap.mapType = MKMapType.hybrid
        //AkronMap.delegate = self
        populateBuildings()
        print("IN PRIMARY VIEW CONTROLLER")
        
        //Draw example path
        //examplePath()
 

        //let path = Bundle.main.url(forResource: "buildings", withExtension: "plist")
        //print("THE BUILDINGS FILE: \(path)")
        //Get user location:
        let currentUserLocation = AkronMap.userLocation.coordinate
        print("User at: \(currentUserLocation.latitude), \(currentUserLocation.longitude)")


        /*
        let human = CLLocationCoordinate2D(latitude: 41.076041, longitude: -80.511550)
        let building = CLLocationCoordinate2D(latitude: 41.076041, longitude: -81.511142)
        let bearing = angle(human, building)
        print("Head: \(bearingString(bearing))")
        */
        
        
        
    }
    
    
    func drawPath(){
        let currentUserLocation = AkronMap.userLocation.coordinate
        

        let gpsLocationStart: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: currentUserLocation.latitude, longitude: currentUserLocation.longitude)
        let startPlacemark: MKPlacemark = MKPlacemark(coordinate: gpsLocationStart)
        let startLocation: MKMapItem = MKMapItem(placemark: startPlacemark)
        
        //Destination
        let gpsLocationEnd: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: targetBuilding.value(forKey: "Latitude") as! Double , longitude: targetBuilding.value(forKey: "Longitude") as! Double)
        
        print("TEST TEST TEST\(gpsLocationStart.latitude) + \(gpsLocationEnd.latitude)")
        let endPlacemark: MKPlacemark = MKPlacemark(coordinate: gpsLocationEnd)
        let endLocation: MKMapItem = MKMapItem(placemark: endPlacemark)
        
        let directionsRequest: MKDirectionsRequest = MKDirectionsRequest()
        directionsRequest.source = startLocation
        directionsRequest.destination = endLocation
        directionsRequest.transportType = MKDirectionsTransportType.walking
        
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
    
    func testTimerFunc(){
        print("The count is \(counter)")
        counter = counter + 1
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
        // read from plist
        //let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        //let url = URL(fileURLWithPath: paths[0]).appendingPathComponent("buildings.plist")
        let url = Bundle.main.url(forResource: "buildings", withExtension: "plist")
        
        print("FILE HERE PLIST \(url)")
        
        guard let buildingData: NSArray = NSArray(contentsOf: url!) else {
            print("ERROR: reading plist from \(url)")
            return
        }
        
        //print(buildingData)
        
        //var buildingsArray: [NSDictionary] = []
        
        for building in buildingData {
            
            let buildingItem = building as! NSDictionary

            guard let buildingName: String = buildingItem["Name"] as? String else{
                print("Invalid building name")
                return
            }
            guard let buildingLatitude: Double = buildingItem["Latitude"] as? Double else{
                print("Invalid building latitude")
                return
            }
            guard let buildingLongitude: Double = buildingItem["Longitude"] as? Double else{
                print("Invalid building longitude")
                return
            }
            
            let buildingDict: NSDictionary = ["Name" : buildingName, "Latitude" : buildingLatitude, "Longitude" : buildingLongitude]
            buildings.append(buildingDict)
            
        }
        
        
        for building in buildings {
        
            let tempBuilding = MKPointAnnotation()
            tempBuilding.coordinate = CLLocationCoordinate2D(latitude: building["Latitude"] as! Double, longitude: building["Longitude"] as! Double)
            tempBuilding.title = (building["Name"] as! String)
            
            AkronMap.addAnnotation(tempBuilding)
        }
        
        
        
        
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
    
    /*
    
    func buildPList() {
        
        //var newBuilding: [NSDictionary] = []
        
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
        
        DispatchQueue(label:"edu.uakron.cs.ios.ZippyMaps").async {
            let testArray = self.newBuilding as NSArray
            if !testArray.write(to: url, atomically: true) {
                print("Error writing plist to \(url)")
            }
        }
        
    }
 
    */

    
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
        
        
        if (targetBuilding.count == 0) {
            print("No target")
        }else{
            print("Given target, drawing path")
            drawPath()
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Switching to: \(segue.destination.title!)")
        print("\(segue.destination)")
        guard let dest = segue.destination as? CoordinatesViewContoller else {
            print("Error assigning destination view controller")
            return
        }
        
        dest.buildings = self.buildings
        print("Sent building data")
    }

}


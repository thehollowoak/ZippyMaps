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
    var addedRoute: Bool = false
    var locations: CLLocationManager = CLLocationManager()
    var counter = 1
    var timerFired: Bool = false
    var validTarget: Bool = false
    
    var newBuilding: [NSDictionary] = []
    var targetBuilding: NSDictionary = [:]
    var buildings: [NSDictionary] = []
    var classes: [ClassSchedule] = [ClassSchedule]()
    var targetBuildingCoordinate: CLLocationCoordinate2D!
    
    
    //var currentTime: Date!
    
    
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
        
        //var testTimer: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.testTimerFunc), userInfo: nil, repeats: true)

        populateBuildings()
        print("buildings: \(buildings)")
        openSchedulePlist()
        print("Loaded classes: \(classes)")
        classes.sort(by: classSorter)
        let currentTime = Date()
        let actualTime = currentTime.timeIntervalSince1970
        
        for scheduleClass in classes {
            if(scheduleClass.startTime.timeIntervalSince1970 > actualTime){

                
                //Get the index
                let index = scheduleClass.rowIndex
                print("The next class index is: \(index)")

                //Parse the coordinates
                guard let targetLongitude = buildings[index].value(forKey: "Longitude") as? Double else {
                    print("Cannot get longitude")
                    break
                }
                guard let targetLatitude = buildings[index].value(forKey: "Latitude") as? Double else {
                    print("Cannot get latitude")
                    break
                }
                targetBuildingCoordinate = CLLocationCoordinate2D(latitude: targetLatitude, longitude: targetLongitude)
                
                
                //Draw the route
                validTarget = true
                break
            }
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
        let areaRegion: CLLocationDistance = 1000
        let defaultRegion = MKCoordinateRegionMakeWithDistance(defaultLocation, areaRegion, areaRegion)
        AkronMap.setRegion(defaultRegion, animated: false)

        AkronMap.mapType = MKMapType.hybrid


        print("IN PRIMARY VIEW CONTROLLER")
        
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
        //let gpsLocationEnd: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: targetBuilding.value(forKey: "Latitude") as! Double , longitude: targetBuilding.value(forKey: "Longitude") as! Double)
        guard let gpsLocationEnd = targetBuildingCoordinate else {
            print("CANNOT ASSIGN END")
            return
        }
        
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

        
        //Bierce
        let gpsLocationEnd: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 41.511142, longitude: -81.51142)
        
        drawRouteOnMap(gpsLocationStart, gpsLocationEnd)
        
        
    }
    
    func drawRouteOnMap(_ start: CLLocationCoordinate2D, _ end: CLLocationCoordinate2D){
        let startPlacemark: MKPlacemark = MKPlacemark(coordinate: start)
        let startLocation: MKMapItem = MKMapItem(placemark: startPlacemark)

        let endPlacemark: MKPlacemark = MKPlacemark(coordinate: end)
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
                //let validRoute: MKRoute = response!.routes[0]
                guard let validRoute: MKRoute = response?.routes[0] else {
                    print("Route error")
                    return
                }
                //self.AkronMap.add(validRoute.polyline, level: MKOverlayLevel.aboveRoads)
                self.classRoute = validRoute
                if(self.addedRoute){
                    self.AkronMap.remove(self.classRoute.polyline)
                    
                    //remove all overlays before adding new one
                    for overlay in self.AkronMap.overlays {
                        self.AkronMap.remove(overlay)
                    }
                    //print("Removed polyline")
                    self.addedRoute = false
                    //print("Overlays : \(self.AkronMap.overlays)")
                }
                self.AkronMap.add(self.classRoute.polyline, level: MKOverlayLevel.aboveRoads)
                self.addedRoute = true
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
        
        /*
        if (targetBuilding.count == 0) {
            print("No target")
        }else{
            print("Given target, drawing path")
            drawPath()
        }
        */
        
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
        //print("didUpdateLocations")
        
        //
        
        
        /*
        let userLocation = AkronMap.userLocation.coordinate
        let building = CLLocationCoordinate2D(latitude: 41.076041, longitude: -81.511142)

        drawRouteOnMap(userLocation, building)
        */
        if(validTarget){
            let userLocation = AkronMap.userLocation.coordinate
            drawRouteOnMap(userLocation, targetBuildingCoordinate)
        }else{
            print("NO TARGET")
        }
        
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

    func openSchedulePlist(){
        print("READING")
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = URL(fileURLWithPath: paths[0]).appendingPathComponent("schedule.plist")
        
        guard let schedule = NSArray(contentsOf: url) else {
            print("ERROR: reading plist from \(url)")
            return
        }
        print("URL HERE: \(url)")
        let tempSchedule: [NSDictionary] = schedule as! [NSDictionary]
        //Blank classes just in case
        classes = []
        for scheduleItem in tempSchedule {
            guard let startTime: Double = scheduleItem["start"] as? Double else{
                print("Invalid start time")
                return
            }
            guard let endTime: Double = scheduleItem["end"] as? Double else{
                print("Invalid end time")
                return
            }
            guard let scheduleBuildingIndex: Int = scheduleItem["id"] as? Int else{
                print("Invalid building index")
                return
            }
            
            let sDate: NSDate = NSDate(timeIntervalSince1970: startTime)
            let eDate: NSDate = NSDate(timeIntervalSince1970: endTime)
            
            
            let addScheduleItem: ClassSchedule = ClassSchedule(sDate, eDate, scheduleBuildingIndex)
            
            print("Schedule item: \(addScheduleItem)")
            
            
            classes.append(addScheduleItem)
        }
    }
    
    func classSorter(_ c1: ClassSchedule, _ c2: ClassSchedule) -> Bool {
        return c1.startTime.timeIntervalSince1970 < c2.startTime.timeIntervalSince1970
    }
}


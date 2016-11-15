//
//  ViewController.swift
//  ZippyMaps
//
//  Created by Kay,Maxwell on 11/15/16.
//  Copyright © 2016 Kay,Maxwell. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var mapSwipeGesture: UISwipeGestureRecognizer!
    
    //UA's GPS coords 41.075931, -81.511134
    @IBOutlet weak var AkronMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultLocation = CLLocationCoordinate2D(latitude: 41.075931, longitude: -81.511134)
        //Set the map to the hybrid display
        AkronMap.mapType = MKMapType.hybrid
        
        //Area in meters
        let areaRegion: CLLocationDistance = 500
        let defaultRegion = MKCoordinateRegionMakeWithDistance(defaultLocation, areaRegion, areaRegion)
        AkronMap.setRegion(defaultRegion, animated: false)
        //print("HERE")
        //print(AkronMap.region)
        AkronMap.mapType = MKMapType.hybrid
        populateBuildings()
        print("IN PRIMARY VIEW CONTROLLER")
        
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

}


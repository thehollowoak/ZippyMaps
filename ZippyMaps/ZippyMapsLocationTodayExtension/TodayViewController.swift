//
//  TodayViewController.swift
//  ZippyMapsLocationTodayExtension
//
//  Created by Kay,Maxwell on 12/16/16.
//  Copyright © 2016 Kay,Maxwell. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateToday()
        
        // Do any additional setup after loading the view from its nib.

        /*
        let sharedData = UserDefaults(suiteName: "group.edu.uakron.cs.mak138.ZippyMapsUserDefaults")
        guard let schedule:[NSDictionary] = sharedData?.array(forKey: "schedule") as! [NSDictionary]? else {
            print("Cannot get user defaults schedule")
            return
        }
        guard let buildings:[NSDictionary] = sharedData?.array(forKey: "buildings") as! [NSDictionary]? else {
            print("Cannot get user defaults buildings")
            return
        }
        
        print("Got: \(schedule)")
        print("Got: \(buildings)")
        
        //classLabel.text = "test"
        //timeLabel.text = "test"
        var classIndex: Int = 0
        var classIndexSet = false
        
        var selectedCS = NSDictionary()
        let currentTime = Date()
        let correctedDate: Int = (Int(currentTime.timeIntervalSince1970 - 259200.0) % 604800)
        
        for cs in schedule {
            if(!classIndexSet){
                selectedCS = cs
                classIndexSet = true
                print("Skip")
                continue
            }
            
            guard let classEndTime: Double = cs["end"] as? Double else{
                print("Invalid end time")
                return
            }
            guard let magicClassEndTime: Double = selectedCS["end"] as? Double else {
                print("Cannot compare classes")
                return
            
            }
            let magicClassEndTimeInt: Int = Int(magicClassEndTime - 259200.0) % 604800
            let classEndTimeInt: Int = Int(classEndTime - 259200.0) % 604800
            
            if(classEndTimeInt < magicClassEndTimeInt){
                print("Changing")
                selectedCS = cs
            }
            
        }
        
        guard let classBuildingIndex = selectedCS["id"] as? Int else {
            print("Invalid building index")
            return
        }
        guard let classEndTime: Double = selectedCS["end"] as? Double else{
            print("Invalid end time")
            return
        }
        
        guard let buildingName = buildings[classBuildingIndex]["Name"] as? String else {
            print("Cannot get name")
            return
        }
        
        let classEndTimeInt: Int = Int(classEndTime - 259200.0) % 604800
        let minutes = classEndTimeInt - correctedDate
        
        classLabel.text = buildingName
        timeLabel.text = "\(minutes / 60) minutes"
        */
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
        updateToday()
    }
    
    func updateToday() {
        let sharedData = UserDefaults(suiteName: "group.edu.uakron.cs.mak138.ZippyMapsUserDefaults")
        guard let schedule:[NSDictionary] = sharedData?.array(forKey: "schedule") as! [NSDictionary]? else {
            print("Cannot get user defaults schedule")
            return
        }
        guard let buildings:[NSDictionary] = sharedData?.array(forKey: "buildings") as! [NSDictionary]? else {
            print("Cannot get user defaults buildings")
            return
        }
        
        print("Got: \(schedule)")
        print("Got: \(buildings)")
        
        //classLabel.text = "test"
        //timeLabel.text = "test"
        var classIndex: Int = 0
        var classIndexSet = false
        
        var selectedCS = NSDictionary()
        let currentTime = Date()
        let correctedDate: Int = (Int(currentTime.timeIntervalSince1970 - 259200.0) % 604800)
        
        for cs in schedule {
            if(!classIndexSet){
                selectedCS = cs
                classIndexSet = true
                print("Skip")
                continue
            }
            
            guard let classEndTime: Double = cs["start"] as? Double else{
                print("Invalid end time")
                return
            }
            guard let magicClassEndTime: Double = selectedCS["start"] as? Double else {
                print("Cannot compare classes")
                return
                
            }
            var magicClassEndTimeInt: Int = Int(magicClassEndTime - 259200.0) % 604800
            var classEndTimeInt: Int = Int(classEndTime - 259200.0) % 604800
            
            if magicClassEndTimeInt < correctedDate {
                magicClassEndTimeInt += correctedDate
            }
            
            if classEndTimeInt < correctedDate {
                classEndTimeInt += correctedDate
            }
            
            if(classEndTimeInt < magicClassEndTimeInt){
                print("Changing")
                selectedCS = cs
            }
            
        }
        
        guard let classBuildingIndex = selectedCS["id"] as? Int else {
            print("Invalid building index")
            return
        }
        guard let classEndTime: Double = selectedCS["start"] as? Double else{
            print("Invalid end time")
            return
        }
        
        guard let buildingName = buildings[classBuildingIndex]["Name"] as? String else {
            print("Cannot get name")
            return
        }
        
        let classEndTimeInt: Int = Int(classEndTime - 259200.0) % 604800
        var minutes = (classEndTimeInt - correctedDate) / 60
        
        if(minutes < 0){
            minutes += 60*24*7
        }
        
        classLabel.text = buildingName
        timeLabel.text = "\(minutes) minutes"

    }
    
    
}

//
//  CoordinatesViewContoller.swift
//  ZippyMaps
//
//  Created by Kay,Maxwell on 11/15/16.
//  Copyright © 2016 Kay,Maxwell. All rights reserved.
//

import UIKit

class CoordinatesViewContoller: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buildingPicker: UIPickerView!
    @IBOutlet weak var selectRouteButton: UIButton!
    @IBOutlet weak var classScheduleTableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    
    var buildingIndex: Int = 0
    
    var classes: [ClassSchedule] = [ClassSchedule]()
    
    var buildings: [NSDictionary] = []
    var classTableRowSelected = false
    //To shut up the compiler
    //var selectedRow:IndexPath = IndexPath(item: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IN SECONDARY VIEW CONTROLLER")
        // Do any additional setup after loading the view.
        
        buildingPicker.delegate = self
        buildingPicker.dataSource = self
        
        //classScheduleTableView.load
        classScheduleTableView.delegate = self
        classScheduleTableView.dataSource = self
        
        openSchedulePlist()
        //loadSampleClasses()
        print("Length of classes: \(classes.count)")
        print("Secondary view controller buildings: \(buildings)")
        
    }
    
    func classSorter(_ c1: ClassSchedule, _ c2: ClassSchedule) -> Bool {
        //return c1.startTime.timeIntervalSince1970 < c2.startTime.timeIntervalSince1970
        
        var c1Start: Int = Int(c1.startTime.timeIntervalSince1970)
        var c2Start: Int = Int(c2.startTime.timeIntervalSince1970)
        
        //1970 DOW correction
        //345600
        c1Start -= 259200
        c2Start -= 259200
        
        c1Start %= 604800
        c2Start %= 604800
        
        print("c1: \(c1.rowIndex) c2: \(c2.rowIndex)")
        print("c1: \(c1Start) c2: \(c2Start)")
        return c1Start < c2Start
    }
    
    func loadSampleClasses() {

        let a = ClassSchedule(NSDate(timeIntervalSince1970: 1480554000), NSDate(timeIntervalSince1970: 1480557600), 0)
        let b = ClassSchedule(NSDate(timeIntervalSince1970: 1480558500), NSDate(timeIntervalSince1970: 1480562100), 1)
        
        classes += [a,b]
        print("CLASSES \(classes)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func routeSelectPress(_ sender: AnyObject) {
        print("Route button pressed")
        var row:Int = 0
        row = buildingPicker.selectedRow(inComponent: row)
        let building = buildings[row]
        guard let name: String = building.value(forKey: "Name") as? String else {
            print("Cannot convert building name to string")
            return
        }
        print("Building: \(name)")

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.buildings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let building = buildings[row]
        guard let name: String = building.value(forKey: "Name") as? String else {
            print("Cannot convert building name to string")
            return "INVALID"
        }
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //label.text = pickerData[row]
        //print("Chose: \(pickerData[row])")
        let building = buildings[row]
        guard let name: String = building.value(forKey: "Name") as? String else {
            print("Cannot convert building name to string")
            return
        }
        print("Building: \(name)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Switching to: \(segue.destination.title)")
        print("\(segue.destination)")
        guard let dest = segue.destination as? ViewController else {
            print("Error assigning destination view controller")
            return
        }
        
        var row:Int = 0
        row = self.buildingPicker.selectedRow(inComponent: row)
        let building = buildings[row]
        
        dest.targetBuilding = building
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TABLEVIEW")
        print(#function)
        
        print("NUMBER OF ROWS \(classes.count)")
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("TABLEVIEW")
        print(#function)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ClassScheduleViewCellTableViewCell
        let cell_class = classes[indexPath.row]
        let building = buildings[cell_class.rowIndex]
        guard let buildingName: String = building.value(forKey: "Name") as? String else {
            print("Could not unwrap building name")
            cell.classNameLabel.text = "INVALID"
            return cell
        }
        //cell.classNameLabel.text = buildingName
        
        let startDOWTLabel = DateFormatter()
        startDOWTLabel.setLocalizedDateFormatFromTemplate("EEE hh:mm")
        let tempStartDate = Date(timeIntervalSince1970: cell_class.startTime.timeIntervalSince1970)
        //cell.startTimeLabel.text = startDOWTLabel.string(from: tempStartDate)
        print("startTimeLabel: \(startDOWTLabel.string(from: tempStartDate))")
        
        let endDOWTLabel = DateFormatter()
        endDOWTLabel.setLocalizedDateFormatFromTemplate("EEE hh:mm")
        let tempEndDate = Date(timeIntervalSince1970: cell_class.endTime.timeIntervalSince1970)
        //cell.endTimeLabel.text = endDOWTLabel.string(from: tempEndDate)
        
        //Temporary fixed label until multi-column implemented
        cell.classNameLabel.text = buildingName + " " + startDOWTLabel.string(from: tempStartDate) + " " + endDOWTLabel.string(from: tempEndDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell: \(indexPath.row) selected")
        print("Item: \(indexPath.item)")
        buildingIndex = indexPath.row
        print("Did select row at \(buildingIndex)")
        classTableRowSelected = true
        //FIXME
        //selectedRow = indexPath
        addButton.setTitle("Update", for: .normal)
        print("Did select row at")
        
        print("Classes: \(classes)")
        
        //Update pickers
        print("building index: \(buildingIndex)")
        let pickedClass: ClassSchedule = classes[buildingIndex]
        //buildingPicker.selectedRow(inComponent: buildingIndex)
        let buildingPickerIndex: Int = classes[buildingIndex].rowIndex
        buildingPicker.selectRow(buildingPickerIndex, inComponent: 0, animated: true)
        let startTime = pickedClass.startTime.timeIntervalSince1970
        let endTime = pickedClass.endTime.timeIntervalSince1970
        let pStart: Date = Date(timeIntervalSince1970: startTime)
        let pEnd: Date = Date(timeIntervalSince1970: endTime)
        startTimePicker.setDate(pStart, animated: true)
        endTimePicker.setDate(pEnd, animated: true)
        
        
        
    }
    

    //Buttons
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        print("Add pressed")
        
        let selectedIndex = buildingPicker.selectedRow(inComponent: 0)
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        let nsStartTime = NSDate(timeIntervalSince1970: startTime.timeIntervalSince1970)
        let nsEndTime =  NSDate(timeIntervalSince1970: endTime.timeIntervalSince1970)

        print("Start: \(startTime.timeIntervalSince1970)")
        print("End: \(endTime.timeIntervalSince1970)")
        //Sanity check function if bad message and break
        if(startTime.timeIntervalSince1970 >= endTime.timeIntervalSince1970){
            //swap
            //print("Start time is greater than end time")
            //startTimePicker.setDate(endTime, animated: true)
            //endTimePicker.setDate(startTime, animated: true)
            let alert = UIAlertController(title: "Alert", message: "End time occurs before start time.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if((endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970) >= 86400.0){
            let alert = UIAlertController(title: "Alert", message: "Invalid class length.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        //Check if will fit in class schedule
        for existingClass in classes {
            if(existingClass == classes[buildingIndex] && classTableRowSelected){
                //A class being edited cannot conflict with it self so skip
                print("Existing class: \(existingClass)")
                //If the class is the one we are editing skip
                print("Skipping")
                continue
            }
            
            let existingStartTime = Int(existingClass.startTime.timeIntervalSince1970) % 604800
            let existingEndTime = Int(existingClass.endTime.timeIntervalSince1970) % 604800
            let intStartTime = Int(startTime.timeIntervalSince1970) % 604800
            let intEndTime = Int(endTime.timeIntervalSince1970) % 604800
            if(intStartTime >= existingStartTime && intStartTime <= existingEndTime){
                let alert = UIAlertController(title: "Alert", message: "Scheduled start time interval conflicts with an existing class.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if(intEndTime >= existingStartTime && intEndTime <= existingEndTime){
                let alert = UIAlertController(title: "Alert", message: "Scheduled end time interval conflicts with an existing class.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
        if(classTableRowSelected){
            //Update behavior
            classTableRowSelected = false
            addButton.setTitle("Add", for: .normal)

            classes[buildingIndex].rowIndex = selectedIndex
            classes[buildingIndex].startTime = nsStartTime
            classes[buildingIndex].endTime = nsEndTime

        }else{
            //Add behavior
            
            //Get index from building as int
            //Get times
            //Create ClassSchedule object
            //Add to classes
            
            //Needs to be var as we'll edit it later
            let addClass: ClassSchedule = ClassSchedule(nsStartTime, nsEndTime, selectedIndex)
            classes.append(addClass)
            
        }
        self.classes.sort(by: classSorter)
        classScheduleTableView.reloadData()
        
        //Reset fields to reasonable values
        //Save plist
        saveSchedulePlist()
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        if(classTableRowSelected){
            classTableRowSelected = false
            addButton.setTitle("Add", for: .normal)
            
            //FIX ME
            //classScheduleTableView.deselectRow(at: selectedRow, animated: true)
        }
        
        //Reset fields to reasonable values
        //Save plist
        saveSchedulePlist()
    }
    
    @IBAction func removeButtonPressed(_ sender: AnyObject) {
        if(classTableRowSelected){
            //Do stuff, otherwise do nothing
            print(#function)
            //classScheduleTableView.
            classes.remove(at: buildingIndex)
            classScheduleTableView.reloadData()
            
            
            classTableRowSelected = false
            addButton.setTitle("Add", for: .normal)
            
            
            saveSchedulePlist()
        }
    }
    
    
    func saveSchedulePlist(){
        // write plist as local document
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url = URL(fileURLWithPath: paths[0]).appendingPathComponent("schedule.plist")
        print(paths[0])
        
        var schedule: [NSDictionary] = []
        
        for item in classes {
            //Class timedate
            let classTD: NSDictionary = ["id" : item.rowIndex, "start" : item.startTime.timeIntervalSince1970, "end" : item.endTime.timeIntervalSince1970]
            print("Class schedule info: \(classTD)")
            schedule.append(classTD)
        }
        
        let sharedData = UserDefaults(suiteName: "group.edu.uakron.cs.mak138.ZippyMapsUserDefaults")
        sharedData?.set(schedule, forKey: "schedule")        
        
        DispatchQueue(label:"edu.uakron.cs.ios.ZippyMaps").async {
            let testArray = schedule as NSArray
            if !testArray.write(to: url, atomically: true) {
                print("Error writing plist to \(url)")
            }
        }
        
        
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
    

    


    
    

}

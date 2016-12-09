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
    
    
    var classes: [ClassSchedule] = [ClassSchedule]()
    
    let pickerData = ["A", "B", "C"]
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
    
    func loadSampleClasses() {
        /*
        let a = ClassSchedule("A")
        let b = ClassSchedule("B")
        let c = ClassSchedule("C")
        */
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
        cell.classNameLabel.text = buildingName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell: \(indexPath.row) selected")
        classTableRowSelected = true
        //FIXME
        //selectedRow = indexPath
        addButton.setTitle("Update", for: .normal)
    }
    

    //Buttons
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        //Sanity check function if bad message and break
        if(!validateClassScheduleItem()){
            //Yell at user
            return
        }
        
        if(classTableRowSelected){
            //Update behavior
            classTableRowSelected = false
            addButton.setTitle("Add", for: .normal)
            
            //FIXME
            //classScheduleTableView.deselectRow(at: selectedRow, animated: true)
        }else{
            //Add behavior
            
            //Get index from building as int
            //Get times
            //Create ClassSchedule object
            //Add to classes
        }
        
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
            guard let buildingIndex: Int = scheduleItem["id"] as? Int else{
                print("Invalid building index")
                return
            }
            
            let sDate: NSDate = NSDate(timeIntervalSince1970: startTime)
            let eDate: NSDate = NSDate(timeIntervalSince1970: endTime)
            
            
            let addScheduleItem: ClassSchedule = ClassSchedule(sDate, eDate, buildingIndex)
            
            print("Schedule item: \(addScheduleItem)")
                

            classes.append(addScheduleItem)
        }
    }
    
    func validateClassScheduleItem() -> Bool{
        //Check if fields valid and fits
        //15 minute?
        return true
    }
    


    
    

}

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
    
    var classes: [ClassSchedule] = [ClassSchedule]()
    
    let pickerData = ["A", "B", "C"]
    var buildings: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IN SECONDARY VIEW CONTROLLER")
        // Do any additional setup after loading the view.
        
        buildingPicker.delegate = self
        buildingPicker.dataSource = self
        
        //classScheduleTableView.load
        classScheduleTableView.delegate = self
        classScheduleTableView.dataSource = self

        loadSampleClasses()
        print("Length of classes: \(classes.count)")
        
    }
    
    func loadSampleClasses() {
        let a = ClassSchedule("A")
        let b = ClassSchedule("B")
        let c = ClassSchedule("C")
        
        classes += [a,b,c]
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
        cell.classNameLabel.text = cell_class.className
        return cell
    }
    


}

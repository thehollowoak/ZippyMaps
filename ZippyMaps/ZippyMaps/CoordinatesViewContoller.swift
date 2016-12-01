//
//  CoordinatesViewContoller.swift
//  ZippyMaps
//
//  Created by Kay,Maxwell on 11/15/16.
//  Copyright © 2016 Kay,Maxwell. All rights reserved.
//

import UIKit

class CoordinatesViewContoller: UIViewController, UIPickerViewDelegate{
    @IBOutlet weak var picker: UIPickerView! = UIPickerView()
    @IBOutlet weak var toTextfield: UITextField!

    var test = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IN SECONDARY VIEW CONTROLLER")
        // Do any additional setup after loading the view.
        picker.isHidden = true
        toTextfield.text = test[0]
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return test.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return test[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        toTextfield.text = test[row]
        picker.isHidden = true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        picker.isHidden = false
        return false
    }


}

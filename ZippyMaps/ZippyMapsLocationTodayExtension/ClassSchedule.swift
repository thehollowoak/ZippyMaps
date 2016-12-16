//
//  ClassSchedule.swift
//  ZippyMaps
//
//  Created by Kay,Maxwell on 12/1/16.
//  Copyright © 2016 Kay,Maxwell. All rights reserved.
//

import UIKit

class ClassSchedule: NSObject {
    
    //var className: String
    var startTime: NSDate
    var endTime: NSDate
    var rowIndex: Int
    
    init( _ start: NSDate, _ end: NSDate, _ index: Int){
        //self.className = building
        self.startTime = start
        self.endTime = end
        self.rowIndex = index
    }
}

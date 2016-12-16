//
//  ClassScheduleTableView.swift
//  ZippyMaps
//
//  Created by Kay,Maxwell on 12/1/16.
//  Copyright © 2016 Kay,Maxwell. All rights reserved.
//

import UIKit

class ClassScheduleTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var c: ClassScheduleViewCellTableViewCell
    
    var classSechedule = ["A", "B", "C"]
    
    func loadClasses() {
        print(#function)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return c
        
    }

}

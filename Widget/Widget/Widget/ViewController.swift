//
//  ViewController.swift
//  Widget
//
//  Created by Tichon,Ryan on 12/8/16.
//  Copyright © 2016 Tichon,Ryan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func Click(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Hello", message: "This is an alert", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/26/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done() {
        println("Concets of the text field: \(textField.text)")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
}

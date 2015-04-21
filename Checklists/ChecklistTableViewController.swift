//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/19/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController {
    
    var _row0text = "Walk the dog"
    var _row1text = "Brush Teeth"
    var _row2text = "Learn iOS development"
    var _row3text = "Soccer practice"
    var _row4text = "Eat ice cream"
    var _row0checked = false
    var _row1checked = true
    var _row2checked = true
    var _row3checked = false
    var _row4checked = true
    var _i = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as! UITableViewCell
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        if indexPath.row == 0 {
            label.text = _row0text
        } else if indexPath.row == 1 {
            label.text = _row1text
        } else if indexPath.row == 2 {
            label.text = _row2text
        } else if indexPath.row == 3 {
            label.text = _row3text
        } else if indexPath.row == 4 {
            label.text = _row4text
        }
        
        configureCheckmarkForCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if indexPath.row == 0 {
                _row0checked = !_row0checked
                println("You pressed \(indexPath.row)")
            } else if indexPath.row == 1 {
                _row1checked = !_row1checked
                println("You pressed \(indexPath.row)")
            } else if indexPath.row == 2 {
                _row2checked = !_row2checked
                println("You pressed \(indexPath.row)")
            } else if indexPath.row == 3 {
                _row3checked = !_row3checked
                println("You pressed \(indexPath.row)")
            } else if indexPath.row == 4 {
                _row4checked = !_row4checked
                println("You pressed \(indexPath.row)")
            }
            
            configureCheckmarkForCell(cell, indexPath: indexPath)
            
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        println("This has been run \(_i) times and we are at index \(indexPath.row)")
        
        var isChecked = false
        
        if indexPath.row == 0 {
            isChecked = _row0checked
            println("\(indexPath.row) is \(isChecked)")
        } else if indexPath.row == 1 {
            isChecked = _row1checked
            println("\(indexPath.row) is \(isChecked)")
        } else if indexPath.row == 2 {
            isChecked = _row2checked
            println("\(indexPath.row) is \(isChecked)")
        } else if indexPath.row == 3 {
            isChecked = _row3checked
            println("\(indexPath.row) is \(isChecked)")
        } else if indexPath.row == 4 {
            isChecked = _row4checked
            println("\(indexPath.row) is \(isChecked)")
        }
        
        if isChecked {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        _i++
    }

}

//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/19/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items: [ChecklistItem]
    
    required init!(coder aDecoder: NSCoder!) {
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item._text = "Walk the dog if I had one"
        row0item._checked = false
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item._text = "Brush my teeth"
        row1item._checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item._text = "Learn iOS development"
        row2item._checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item._text = "Gym"
        row3item._checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item._text = "Go to Chipotle"
        row4item._checked = true
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item._text = "Buy new Macbook"
        row5item._checked = false
        items.append(row5item)
        
        super.init(coder: aDecoder)
    }

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
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as! UITableViewCell
        
        let item = items[indexPath.row]
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item._text
        
        configureTextForCell(cell, withCheclistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = items[indexPath.row]
            item._checked = !item._checked
            
            configureTextForCell(cell, withCheclistItem: item)
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 1
        items.removeAtIndex(indexPath.row)
        
        //2
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        if item._checked {
            label.text = "√"
        } else {
            label.text = ""
        }
        
    }
    
    func configureTextForCell(cell: UITableViewCell, withCheclistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item._text
    }
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = items.count
        
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = find(items, item) {
            let indexPath = NSIndexPath (forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withCheclistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
}

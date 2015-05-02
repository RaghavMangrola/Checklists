//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/19/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController, AddItemViewControllerDelegate {
    
    var _items: [ChecklistItem]
    
    required init!(coder aDecoder: NSCoder!) {
        _items = [ChecklistItem]()
        
        let _row0item = ChecklistItem()
        _row0item._text = "Walk the dog if I had one"
        _row0item._checked = false
        _items.append(_row0item)
        
        let _row1item = ChecklistItem()
        _row1item._text = "Brush my teeth"
        _row1item._checked = true
        _items.append(_row1item)
        
        let _row2item = ChecklistItem()
        _row2item._text = "Learn iOS development"
        _row2item._checked = true
        _items.append(_row2item)
        
        let _row3item = ChecklistItem()
        _row3item._text = "Gym"
        _row3item._checked = false
        _items.append(_row3item)
        
        let _row4item = ChecklistItem()
        _row4item._text = "Go to Chipotle"
        _row4item._checked = true
        _items.append(_row4item)
        
        let _row5item = ChecklistItem()
        _row5item._text = "Buy new Macbook"
        _row5item._checked = false
        _items.append(_row5item)
        
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
        return _items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as! UITableViewCell
        
        let item = _items[indexPath.row]
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item._text
        
        configureTextForCell(cell, withCheclistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = _items[indexPath.row]
            item._checked = !item._checked
            
            configureTextForCell(cell, withCheclistItem: item)
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // 1
        _items.removeAtIndex(indexPath.row)
        
        //2
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
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
    
    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = _items.count
        
        _items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! AddItemViewController
            controller.delegate = self
        }
    }

}

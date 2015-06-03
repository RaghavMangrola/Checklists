//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Raghav Mangrola on 5/11/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
  
  var dataModel: DataModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    println("AllListsViewController\n\tviewDidLoad()")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.delegate = self
    
    let index = dataModel.indexOfSelectedChecklists
    if index >= 0 && index < dataModel.lists.count {
      let checklist = dataModel.lists[index]
      performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    println("AllListsViewController\n\tviewDidAppear()")
  }
  
  /** 
      Runs when the view is about to become visible but the animation hasn't started yet. "tableView.reloadData" will cause tableView(cellForRowAtIndexPath) to be called again for every visible row.
    */
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    println("AllListsViewController\n\tviewWillAppear()")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return dataModel.lists.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellIdentifier = "Cell"
    var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    
    if cell == nil {
      cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
    }
    
    let checklist = dataModel.lists[indexPath.row]
    cell.textLabel!.text = checklist.name
    cell.accessoryType = .DetailDisclosureButton
    
    let count = checklist.countUncheckedItems()
    // checklist.items.count returns how many items are in the checklist array
    if checklist.items.count == 0 {
      cell.detailTextLabel!.text = "(No items)"
    } else if count == 0{
      cell.detailTextLabel!.text = "All Done!"
    } else {
      cell.detailTextLabel!.text = "\(count) Remaining"
    }
    
    println("AllListsViewController\n\ttableView(cellForRowAtIndexPath)")
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    dataModel.indexOfSelectedChecklists = indexPath.row
    
    let checklist = dataModel.lists[indexPath.row]
    performSegueWithIdentifier("ShowChecklist", sender: checklist)
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle,forRowAtIndexPath indexPath: NSIndexPath) {
    dataModel.lists.removeAtIndex(indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowChecklist" {
      let controller = segue.destinationViewController as! ChecklistViewController
      controller.checklist = sender as! Checklist
    } else if segue.identifier == "AddChecklist" {
      let navigationController = segue.destinationViewController as! UINavigationController
      let controller = navigationController.topViewController as! ListDetailViewController
      controller.delegate = self
      controller.checklistToEdit = nil
    }
  }
  
  override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as! UINavigationController
    let controller = navigationController.topViewController as! ListDetailViewController
    controller.delegate = self
    
    let checklist = dataModel.lists[indexPath.row]
    controller.checklistToEdit = checklist
    
    presentViewController(navigationController, animated: true, completion: nil)
  }
  
  func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
    let newRowIndex = dataModel.lists.count
    dataModel.lists.append(checklist)
    
    let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
    let indexPaths = [indexPath]
    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist){
    if let index = find(dataModel.lists, checklist) {
      let indexPath = NSIndexPath(forRow: index, inSection: 0)
      if let cell = tableView.cellForRowAtIndexPath(indexPath){
        cell.textLabel!.text = checklist.name
      }
    }
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    if viewController === self {
      dataModel.indexOfSelectedChecklists = -1
      println("AllListsViewController\n\tnavigationController(willShowViewController)")
    }
  }
  
}

//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/26/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit
import XCGLogger

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
  func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var dueDateLabel: UILabel!
  
  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?
  var dueDate = NSDate()
  var datePickerVisible = false
  
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  
  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text
      item.shouldRemind = shouldRemindSwitch.on
      item.dueDate = dueDate
      delegate?.itemDetailViewController(self, didFinishEditingItem: item)
      log.debug("We are editing an item")
    } else {
      let item = ChecklistItem()
      item.text = textField.text
      item.checked = false
      item.shouldRemind = shouldRemindSwitch.on
      item.dueDate = dueDate
      delegate?.itemDetailViewController(self, didFinishAddingItem: item)
      log.debug("We are adding an item")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44
    
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBarButton.enabled = true
      shouldRemindSwitch.on = item.shouldRemind
      dueDate = item.dueDate
    }
    updateDueDateLabel()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  /**
  
  */
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //1. Check whether this is the index-path for the row with the date picker
    if indexPath.section == 1 && indexPath.row == 2 {
      //2. Ask the table view whether it already has the date picker cell. If not, then create a new one. The selection style is .none
      // because you don't want to show a selected state for this cell when the user taps it.
      var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
      if cell == nil {
        cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
        cell.selectionStyle = .None
        //3. Create a new UIDatePicker component. It has a tag (100) so you can easily find this date picker later.
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
        datePicker.tag = 100
        cell.contentView.addSubview(datePicker)
        //4. Tell the date picker to call the method dateChanged() whenver the user picks a new date. You have seen how to connect actions methods from
        // Interface Buidler; this is how you do it from code.
        // You put the name of the method inside a string. The : after the name signifies that dateChanged() takes a single parameter, which will be a reference
        // to the UIDatePicker.
        // The Selector() thingie tells Swift that this isn't a normal string but the name of a method. Now the UIDatePicker's Value Changed event triggers the dateChanged()
        // Method
        datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
      }
      return cell
      //5. For any index-paths that are not the date picker cell, call through to super (which is UITableViewController). This is the trick that makes sure the
      // static cells still work
    } else {
      return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    }
  }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if indexPath.section == 1 && indexPath.row == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let oldText: NSString = textField.text
    let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
    
    doneBarButton.enabled = (newText.length > 0)
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    hideDatePicker()
  }
  
  /**
  We're formatting the time here. We have a style to the Date (MediumStyle) and a style for the time (ShortStyle)
  Then we ask it to format the NSDate Object (dueDate) into a string
  */
  func updateDueDateLabel() {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    dueDateLabel.text = formatter.stringFromDate(dueDate)
  }
  
  /**
  indexPathDateRow is saying that the datePicker should show up in the second Row, and the second Section (index starts at 0)
  indexPathDatePicker is saying that the datePicker should show up in the third Row, and the second Section (index starts at 0)
  Then we insertRowsAtIndexPaths(indexPathdatePicker) because there are only two rows being show.
  */
  func showDatePicker() {
    datePickerVisible = true
    
    let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
    let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
    
    if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
      dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
    }
    
    tableView.beginUpdates()
    tableView.insertRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
    tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
    tableView.endUpdates()
    
    // This locates the UIDatePicker component in the new cell, and give it the proper date
    if let pickerCell = tableView.cellForRowAtIndexPath(indexPathDatePicker) {
      let datePicker = pickerCell.viewWithTag(100) as! UIDatePicker
      datePicker.setDate(dueDate, animated: false)
    }
  }
  
  
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 1 && datePickerVisible {
      return 3
    } else {
      return super.tableView(tableView, numberOfRowsInSection: section)
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 1 && indexPath.row == 2 {
      return 217
    } else {
      return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    textField.resignFirstResponder()
    
    if indexPath.section == 1 && indexPath.row == 1 {
      if !datePickerVisible {
        showDatePicker()
      } else {
        hideDatePicker()
      }
    }
  }
  
  override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
    if indexPath.section == 1 && indexPath.row == 2{
      indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
    }
    return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
  }
  
  
  
  func hideDatePicker() {
    if datePickerVisible {
      datePickerVisible = false
      
      let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
      let indexPathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
      
      if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
        cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
      }
      
      tableView.beginUpdates()
      tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
      tableView.deleteRowsAtIndexPaths([indexPathDatePicker], withRowAnimation: .Fade)
      tableView.endUpdates()
    }
  }
  
  func dateChanged(datePicker: UIDatePicker) {
    dueDate = datePicker.date
    log.debug("\(self.dueDate)")
    updateDueDateLabel()
  }
}

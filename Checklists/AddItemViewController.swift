//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/26/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(controller: AddItemViewController)
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _doneBarButton: UIBarButtonItem!
    
    weak var _delegate: AddItemViewControllerDelegate?
    var _itemToEdit: ChecklistItem?
    
    @IBAction func cancel() {
        _delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = _itemToEdit {
            item._text = _textField.text
            _delegate?.addItemViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item._text = _textField.text
            item._checked = false
            _delegate?.addItemViewController(self, didFinishAddingItem: item)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let item = _itemToEdit {
            title = "Edit Item"
            _textField.text = item._text
            _doneBarButton.enabled = true
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        _textField.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        _doneBarButton.enabled = (newText.length > 0)
        return true
    }
}

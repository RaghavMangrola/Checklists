//
//  Checklist.swift
//  Checklists
//
//  Created by Raghav Mangrola on 5/18/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
  var name = ""
  var items = [ChecklistItem]()
  
  init(name: String) {
    self.name = name
    super.init()
  }
  
  required init(coder aDecoder: NSCoder) {
    name = aDecoder.decodeObjectForKey("Name") as! String
    items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
    super.init()
  }
   
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(name, forKey: "Name")
    aCoder.encodeObject(items, forKey: "Items")
  }
  
  /**
      This method can ask any Checklist object how many of it's ChecklistItem object are not checked yet. "if !item.checked" translates to "if not item.checked" in english
  
      :returns: returns count of unchecked items
    */
  func countUncheckedItems() -> Int {
    var count = 0
    for item in items {
      if !item.checked {
        count += 1
      }
    }
    println("Checklist\n\tcountUncheckedItems()\n\tNumber of unchecked items is \(count)")
    return count
  }
}
//
//  DataModel.swift
//  Checklists
//
//  Created by Raghav Mangrola on 5/26/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import Foundation

class DataModel {
  var lists = [Checklist]()
  var indexOfSelectedChecklists: Int {
    get {
      return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
    }
    set {
      NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
    }
  }
  
  init() {
    loadChecklists()
    registerDefaults()
    handleFirstTime()
    println("DataModel\n\tinit()")
  }
  
  class func nextChecklistItemID() -> Int {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let itemID = userDefaults.integerForKey("ChecklistItemID")
    userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
    userDefaults.synchronize()
    return itemID
  }
  
  func documentsDirectory() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
    return paths[0]
  }
  
  func dataFilePath() -> String {
    return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
  }
  
  func saveChecklists() {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(lists, forKey: "Checklists")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
  }
  
  func loadChecklists() {
    let path = dataFilePath()
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
      if let data = NSData(contentsOfFile: path) {
        let unarchiver =  NSKeyedUnarchiver(forReadingWithData: data)
        lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
        unarchiver.finishDecoding()
        sortChecklists()
      }
    }
  }
  
  func registerDefaults() {
    let dictionary = ["ChecklistIndex": -1, "FirstTime":true, "ChecklistItemID": 0 ]
    NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
  }
  
  /**
  First we check NSUserDefaults for the value of the "FirstTime"
  key. If it's true then the following if-statement is run so
  a new Checklist object is created and added to the array.
  */
  func handleFirstTime() {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let firstTime = userDefaults.boolForKey("FirstTime")
    if firstTime {
      let checklist = Checklist(name: "List")
      lists.append(checklist)
      indexOfSelectedChecklists = 0
      userDefaults.setBool(false, forKey: "FirstTime")
      println("DataModel\n\thandleFirstTime()\n\t\tif-statement ran")
    }
    println("DataModel\n\thandleFirstTime() is \(firstTime)")
  }
  /**
  Tells the lists array that the Checklists it contains should be sorted using this formula. The forumla is insaide a closure { }. The sort algorithm will repeatedly ask if one Checklist object comes before another, based on our rules for sorting. We chose to sort by name so localizedStandardCompare() will compare the two name strings, it takes into considereation the rules of the current locale. "a" and "A" are considered equal.
  */
  func sortChecklists() {
    lists.sort({checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == NSComparisonResult.OrderedAscending})
    println("DataModel\n\tsortChecklists()")
  }
}

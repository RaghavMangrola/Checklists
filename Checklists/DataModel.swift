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
      }
    }
  }
  
  func registerDefaults() {
    let dictionary = ["FirstTime": true]
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
}


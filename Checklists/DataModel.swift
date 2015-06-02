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
    println("init in DataModel has run")
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
    let dictionary = ["ChecklistIndex": -1]
    NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
  }
}

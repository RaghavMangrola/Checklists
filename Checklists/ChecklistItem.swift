//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/21/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  var dueDate = NSDate()
  var shouldRemind = false
  var itemID: Int
  
  func toggleChecked() {
    checked = !checked
  }
  
  override init() {
    itemID = DataModel.nextChecklistItemID()
    super.init()
  }
  
  required init(coder aDecoder: NSCoder) {
    text = aDecoder.decodeObjectForKey("Text") as! String
    checked = aDecoder.decodeBoolForKey("Checked")
    dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
    shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
    itemID = aDecoder.decodeIntegerForKey("ItemID")
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(text, forKey: "Text")
    aCoder.encodeBool(checked, forKey: "Checked")
    aCoder.encodeObject(dueDate, forKey: "DueDate")
    aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
    aCoder.encodeInteger(itemID, forKey: "ItemID")
  }
  
  /**
        If notificationForThisItem returns a valid UILocalNotification object we cancel it.
        Next we compare the item's dueDate with the current date (NSDate()). If the due date is not (!=) in the past, then the if statment is true and executes.
        In the if statement we create a UILocalNotification object and give it the item's dueDate and text. We also add a userInfo dectionary with the item's
        ID as it's only contents.
  */
  func scheduleNotification() {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
    if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
      let localNotification = UILocalNotification()
      localNotification.fireDate = dueDate
      localNotification.timeZone = NSTimeZone.defaultTimeZone()
      localNotification.alertBody = text
      localNotification.soundName = UILocalNotificationDefaultSoundName
      localNotification.userInfo = ["ItemID": itemID]
      
      UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
      }
  }
  
  /**
        Ask UIApplication for a list of all scheduled notifications, then it loops through that list and looks at each notification one by one
        The notification should have an "ItemID" value inside the userInfo dictionary, if the value exists and equals the itemID property, then we've
        found a notification that belongs to this ChecklistItem. If none of hte local notifications match, or if there aren't any to begin with, the
        method returns nil.
  */
  func notificationForThisItem() -> UILocalNotification? {
    let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification]
    for notification in allNotifications {
      if let number = notification.userInfo?["ItemID"] as? NSNumber {
        if number.integerValue == itemID {
          return notification
        }
      }
    }
    return nil
  }
  
  deinit {
    let existingNotification = notificationForThisItem()
    if let notification = existingNotification {
      UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
  }
}
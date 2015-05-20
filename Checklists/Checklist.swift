//
//  Checklist.swift
//  Checklists
//
//  Created by Raghav Mangrola on 5/18/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import UIKit

class Checklist: NSObject {
  var name = ""
  
  init(name: String) {
    self.name = name
    super.init()
  }
}
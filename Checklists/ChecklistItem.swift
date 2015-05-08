//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/21/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override init() {
        super.init()
    }
}

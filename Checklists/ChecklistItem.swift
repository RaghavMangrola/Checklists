//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Raghav Mangrola on 4/21/15.
//  Copyright (c) 2015 Raghav Mangrola. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var _text = ""
    var _checked = false
    
    func toggleChecked() {
        _checked = !_checked
    }
}

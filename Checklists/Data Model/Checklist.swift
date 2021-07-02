//
//  Checklist.swift
//  Checklists
//
//  Created by Tolga PIRTURK on 29.03.2021.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"
    
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
//        var count = 0
//        for item in items where !item.checked {
//            count += 1
//        }
//        return count
        return items.filter { !$0.checked }.count
    }
    
//    func countUncheckedItemsFunctional() -> Int {
//        return items.reduce(0) {
//            cnt,item in cnt + (item.checked ? 0 : 1)
//        }
//    }
    
    func sortChecklistItems() {
        items.sort { item1, item2 in
            item1.text.localizedStandardCompare(item2.text) == .orderedAscending
        }
    }
}

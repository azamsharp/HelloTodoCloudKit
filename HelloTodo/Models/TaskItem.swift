//
//  TaskItem.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/15/22.
//

import Foundation
import CloudKit

enum TaskRecordKeys: String {
    case type = "TaskItem"
    case name
    case dateAssigned
    case isCompleted
}

struct TaskItem {
    var recordId: CKRecord.ID?
    let name: String
    let dateAssigned: Date
    var isCompleted: Bool = false
}

extension TaskItem {
    init?(record: CKRecord) {
        
        guard let name = record["name"] as? String,
              let dateAssigned = record["dateAssigned"] as? Date,
              let isCompleted = record["isCompleted"] as? Bool else {
            return nil
        }
        
        self.init(recordId: record.recordID, name: name, dateAssigned: dateAssigned, isCompleted: isCompleted)
    }
}


extension TaskItem {
    
    var record: CKRecord {
        let record = CKRecord(recordType: TaskRecordKeys.type.rawValue)
        record["name"] = name
        record["dateAssigned"] = dateAssigned
        record["isCompleted"] = isCompleted
        return record
    }
}

//
//  Model.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/15/22.
//

import Foundation
import CloudKit

@MainActor
class Model: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
    @Published var tasks: [TaskItem] = []
    
    func populateTasks() async throws {
        
        let query = CKQuery(recordType: TaskRecordKeys.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]
        let result = try await db.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        tasks = records.compactMap {
            TaskItem(record: $0)
        }
        
    }
    
    func addTask(task: TaskItem) async throws {
        let record = try await db.save(task.record)
        guard let task = TaskItem(record: record) else { return }
        tasks.append(task)
    }
    
}

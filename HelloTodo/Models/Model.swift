//
//  Model.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/15/22.
//

import Foundation
import CloudKit

enum TaskError: Error {
    case operationFailed(Error)
}

enum UserAccountError: Error {
    case notSignedIn
}

@MainActor
class Model: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
    @Published private var tasksDictionary: [CKRecord.ID: TaskItem] = [:]
    
    var tasks: [TaskItem] {
        tasksDictionary.values.compactMap { $0 }
    }
    
    func checkUserLoginToiCloud() async throws -> Bool {
        try await CKContainer.default().isUserLoggedIn
    }
    
    func populateTasks() async throws {
        
        let query = CKQuery(recordType: TaskRecordKeys.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]
        let result = try await db.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        records.forEach { record in
            tasksDictionary[record.recordID] = TaskItem(record: record)
        }
    }
    
    func addTask(task: TaskItem) async throws {
        let record = try await db.save(task.record)
        guard let task = TaskItem(record: record) else { return }
        
        tasksDictionary[task.recordId!] = task
    }
    
    func deleteTask(taskToBeDeleted: TaskItem) async throws {
        
        tasksDictionary.removeValue(forKey: taskToBeDeleted.recordId!)
        
        do {
            let _ = try await db.deleteRecord(withID: taskToBeDeleted.recordId!)
        } catch {
            // put back the task into the tasks array
            tasksDictionary[taskToBeDeleted.recordId!] = taskToBeDeleted
            // throw the exception
            throw TaskError.operationFailed(error)
        }
    }
    
    func updateTask(editedTask: TaskItem) async throws {
        
        tasksDictionary[editedTask.recordId!]?.isCompleted = editedTask.isCompleted
        
        do {
        
            let record = try await db.record(for: editedTask.recordId!)
            record["isCompleted"] = editedTask.isCompleted
            
            // save it
            try await db.save(record)
        } catch {
            
            // rollback the update
            tasksDictionary[editedTask.recordId!] = editedTask
        }
        
    }
    
    func filterTasks(by filterOption: FilterOptions) -> [TaskItem] {
        switch filterOption {
            case .all:
                return tasks
            case .completed:
                return tasks.filter { $0.isCompleted }
            case .incomplete:
                return tasks.filter { !$0.isCompleted }
        }
    }
    
}

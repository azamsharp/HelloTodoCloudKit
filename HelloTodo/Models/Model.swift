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
    
    func deleteTask(taskToBeDeleted: TaskItem) async throws {
        
        // get the index of the task item
        guard let index = tasks.firstIndex(where: { $0.recordId == taskToBeDeleted.recordId }) else {
            return
        }
        
        // delete the task from the tasks array
        tasks.remove(at: index)
        
        do {
            let _ = try await db.deleteRecord(withID: taskToBeDeleted.recordId!)
        } catch {
            // put back the task into the tasks array
            tasks.insert(taskToBeDeleted, at: index)
            // throw the exception
            throw TaskError.operationFailed(error)
        }
    }
    
    func updateTask(editedTask: TaskItem) async throws {
        
        // get the index of the task item
        guard let index = tasks.firstIndex(where: { $0.recordId == editedTask.recordId }) else {
            return
        }
        
        tasks[index].isCompleted = editedTask.isCompleted
        
        do {
        
            let record = try await db.record(for: editedTask.recordId!)
            record["isCompleted"] = editedTask.isCompleted
            
            // save it
            try await db.save(record)
        } catch {
            
            // rollback the update
            tasks[index].isCompleted = !editedTask.isCompleted
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

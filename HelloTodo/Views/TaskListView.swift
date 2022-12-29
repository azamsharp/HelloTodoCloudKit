//
//  TaskListView.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/19/22.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject private var model: Model
    @State private var errorWrapper: ErrorWrapper?
    let tasks: [TaskItem]
    
    private func updateTask(task: TaskItem) {
        Task {
            do {
                try await model.updateTask(editedTask: task)
            } catch {
                errorWrapper = ErrorWrapper(error: error, guidance: "Failed to update task. Try again later.")
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(tasks, id: \.recordId) { task in
                TaskItemView(taskItem: task, onUpdate: updateTask)
            }.onDelete { indexSet in
                
                guard let index = indexSet.map({ $0 }).last else {
                    return
                }
                
                let taskItem = model.tasks[index]
                Task {
                    do {
                        try await model.deleteTask(taskToBeDeleted: taskItem)
                    } catch {
                        errorWrapper = ErrorWrapper(error: error, guidance: "Failed to delete task. Try again later.")
                    }
                }
            }
        }.sheet(item: $errorWrapper) { errorWrapper in
            ErrorView(errorWrapper: errorWrapper)
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(tasks: [TaskItem(name: "Mow the lawn", dateAssigned: Date())])
            .environmentObject(Model())
    }
}

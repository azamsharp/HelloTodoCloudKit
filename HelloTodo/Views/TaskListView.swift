//
//  TaskListView.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/19/22.
//

import SwiftUI

struct TaskListView: View {
    
    @EnvironmentObject private var model: Model
    let tasks: [TaskItem]
    
    private func updateTask(task: TaskItem) {
        Task {
            do {
                try await model.updateTask(editedTask: task)
            } catch {
                // should display error on the screen
                print(error)
            }
        }
    }
    
    var body: some View {
        List(tasks, id: \.recordId) { task in
            TaskItemView(taskItem: task, onUpdate: updateTask)
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(tasks: [TaskItem(name: "Mow the lawn", dateAssigned: Date())])
            .environmentObject(Model())
    }
}

//
//  TaskItemView.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/19/22.
//

import SwiftUI

struct TaskItemView: View {
    
    let taskItem: TaskItem
    let onUpdate: (TaskItem) -> Void
    
    var body: some View {
        HStack {
            Text(taskItem.name)
            Spacer()
            Image(systemName: taskItem.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    var taskToUpdate = taskItem
                    taskToUpdate.isCompleted = !taskItem.isCompleted
                    onUpdate(taskToUpdate)
                }
        }
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        TaskItemView(taskItem: TaskItem(name: "Mow the lawn", dateAssigned: Date()), onUpdate: { _ in })
    }
}

//
//  TodoListScreen.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/15/22.
//

import SwiftUI

struct TodoListScreen: View {
    
    @EnvironmentObject private var model: Model
    @State private var taskName: String = ""
    
    var body: some View {
        VStack {
            
            TextField("Enter task", text: $taskName)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    print("onSubmit")
                    let task = TaskItem(name: taskName, dateAssigned: Date())
                        Task {
                            try await model.addTask(task: task)
                            taskName = ""
                        }
                   
                }
            
            List(model.tasks, id: \.recordId) { task in
                Text(task.name)
            }
            
            Spacer()
            
        }
        .task {
            do {
                try await model.populateTasks()
            } catch {
                print(error)
            }
        }
        .padding()
    }
}

struct TodoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        TodoListScreen().environmentObject(Model())
    }
}

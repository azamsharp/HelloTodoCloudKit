//
//  TodoListScreen.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/15/22.
//

import SwiftUI

enum FilterOptions: String, CaseIterable, Identifiable {
    case all
    case completed
    case incomplete
}

extension FilterOptions {
    
    var displayName: String {
        rawValue.capitalized
    }
    
    var id: String {
        rawValue
    }
}

struct TodoListScreen: View {
    
    @EnvironmentObject private var model: Model
    @State private var taskName: String = ""
    @State private var filterOption: FilterOptions = .all
    
    var filteredTasks: [TaskItem] {
        model.filterTasks(by: filterOption)
    }
    
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
            
            // segmented control
            Picker("Select", selection: $filterOption) {
                ForEach(FilterOptions.allCases) { option in
                    Text(option.displayName).tag(option)
                }
            }.pickerStyle(.segmented)
            
            List(filteredTasks, id: \.recordId) { task in
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

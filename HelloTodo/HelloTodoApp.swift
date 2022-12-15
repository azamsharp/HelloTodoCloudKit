//
//  HelloTodoApp.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/15/22.
//

import SwiftUI

@main
struct HelloTodoApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListScreen().environmentObject(Model())
        }
    }
}

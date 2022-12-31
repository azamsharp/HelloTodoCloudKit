//
//  HelloTodoApp.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/15/22.
//

import SwiftUI

@main
struct HelloTodoApp: App {
    
    @State private var isUserLoggedIn: Bool = false
    @StateObject private var model = Model()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isUserLoggedIn {
                    TodoListScreen()
                        .environmentObject(model)
                } else {
                    ErrorView(errorWrapper: ErrorWrapper(error: UserAccountError.notSignedIn, guidance: "Please sign in to iCloud.")) {
                        Button("Open settings") {
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                            Task {
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    let _ = await UIApplication.shared.open(settingsUrl)
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: scenePhase, perform: { newPhase in
                if newPhase == .active {
                    Task {
                        isUserLoggedIn = (try? await validateUserLoginToiCloud()) ?? false
                    }
                }
            })
        }
    }
}

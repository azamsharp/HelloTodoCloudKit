//
//  ErrorView.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/29/22.
//

import SwiftUI

struct ErrorView<Content: View>: View {
    
    let errorWrapper: ErrorWrapper
    var content: () -> Content?
    
    init(errorWrapper: ErrorWrapper, @ViewBuilder content: @escaping () -> Content? = { EmptyView() }) {
        self.errorWrapper = errorWrapper
        self.content = content 
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Error has occurred!")
                .font(.title)
            Text(errorWrapper.error.localizedDescription)
            Text(errorWrapper.guidance)
                .padding(.top)
        
           content()
            
            Spacer()
        }.padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16.0)
    }
}


struct ErrorView_Previews: PreviewProvider {
    
    enum SampleError: Error {
        case operationFailed
    }
    
    static var previews: some View {
        Group {
            // Just displaying the error
            ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed, guidance: "Operation failed. Try again later."))
            
            // displaying the error with an action
            ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed, guidance: "Operation failed. Try again later.")) {
                Button("Login to iCloud") {
                    // code to open the settings etc
                }
            }
        }
    }
}

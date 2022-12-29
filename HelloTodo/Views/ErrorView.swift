//
//  ErrorView.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/29/22.
//

import SwiftUI

struct ErrorView: View {
    
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Error has occurred!")
                .font(.title)
            Text(errorWrapper.error.localizedDescription)
            Text(errorWrapper.guidance)
                .padding(.top)
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
        ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed, guidance: "Operation failed. Try again later."))
    }
}

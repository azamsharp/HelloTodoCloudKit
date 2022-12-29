//
//  ErrorWrapper.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/29/22.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    let guidance: String
}

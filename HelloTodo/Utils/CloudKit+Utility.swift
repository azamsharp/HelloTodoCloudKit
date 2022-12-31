//
//  CloudKit+Utility.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/31/22.
//

import Foundation
import CloudKit

enum UserAccountError: Error {
    case notSignedIn
}

func validateUserLoginToiCloud() async throws -> Bool {
        let container = CKContainer.default()
        let accountStatus = try await container.accountStatus()
        
        switch accountStatus {
            case .couldNotDetermine, .restricted, .noAccount, .temporarilyUnavailable:
                return false
            case .available:
                return true
            @unknown default:
                return false
        }
}

//
//  CKContainer+Extensions.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/31/22.
//

import Foundation
import CloudKit

extension CKContainer {
    
    var isUserLoggedIn: Bool {
        get async throws {
            let accountStatus = try await self.accountStatus()
            switch accountStatus {
                case .couldNotDetermine, .restricted, .noAccount, .temporarilyUnavailable:
                    return false
                case .available:
                    return true
                @unknown default:
                    return false
            }
        }
    }
    
}

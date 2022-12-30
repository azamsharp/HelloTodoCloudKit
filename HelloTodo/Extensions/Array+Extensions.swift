//
//  Array+Extensions.swift
//  HelloTodo
//
//  Created by Mohammad Azam on 12/30/22.
//

import Foundation
import CloudKit

extension Array where Element == TaskItem {
    
    subscript(recordId: CKRecord.ID) -> TaskItem {
            get {
                self[recordId]
            }
            set {
                //imageStore[url] = newValue
                self[recordId] = newValue 
            }
        }
    
}

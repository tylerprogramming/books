//
//  ApplicationData.swift
//  books
//
//  Created by Tyler Reed on 4/1/22.
//

import SwiftUI
import CoreData

class ApplicationData: ObservableObject {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "books")
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}

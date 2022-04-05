//
//  booksApp.swift
//  books
//
//  Created by Tyler Reed on 4/1/22.
//

import SwiftUI

@main
struct booksApp: App {
    @StateObject var appData = ApplicationData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appData)
                .environment(\.managedObjectContext, appData.container.viewContext)
        }
    }
}

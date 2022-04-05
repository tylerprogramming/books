//
//  InsertAuthorView.swift
//  books
//
//  Created by Tyler Reed on 4/1/22.
//

import SwiftUI
import CoreData

struct InsertAuthorView: View {
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.dismiss) var dismiss
    
    @State private var inputName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                TextField("Insert Name", text: $inputName)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Spacer()
                Button("Save") {
                    let newName = inputName.trimmingCharacters(in: .whitespaces)
                    
                    if !newName.isEmpty {
                        Task(priority: .high) {
                            await storeAuthor(name: newName)
                        }
                    }
                }
            }
        }
    }
    
    func storeAuthor(name: String) async {
        await dbContext.perform {
            let request: NSFetchRequest<Authors> = Authors.fetchRequest()
            request.predicate = NSPredicate(format: "name = %@", name)
            
            if let total = try? self.dbContext.count(for: request), total == 0 {
                let newAuthor = Authors(context: dbContext)
                newAuthor.name = name
                
                do {
                    try dbContext.save()
                    dismiss()
                } catch {
                    print("Error saving Authors record.")
                }
            }
        }
    }
}

struct InsertAuthorView_Previews: PreviewProvider {
    static var previews: some View {
        InsertAuthorView()
    }
}

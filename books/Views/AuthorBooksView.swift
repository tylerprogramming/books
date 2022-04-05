//
//  AuthorBooksView.swift
//  books
//
//  Created by Tyler Reed on 4/4/22.
//

import SwiftUI

struct AuthorBooksView: View {
    @FetchRequest(sortDescriptors: []) var listOfBooks: FetchedResults<Books>
    
    var selectedAuthor: Authors?
    
    init(selectedAuthor: Authors?) {
        self.selectedAuthor = selectedAuthor
        
        if selectedAuthor != nil {
            _listOfBooks = FetchRequest(sortDescriptors: [SortDescriptor(\Books.title, order: .forward)], predicate: NSPredicate(format: "author = %@", selectedAuthor!), animation: .default)
        }
    }
    
    var body: some View {
        List {
            ForEach(listOfBooks) { book in
                Text(book.title ?? "Undefined")
            }
        }
        .navigationTitle(selectedAuthor?.name ?? "Undefined")
    }
}

struct AuthorBooksView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorBooksView(selectedAuthor: nil)
    }
}

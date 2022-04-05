//
//  ContentView.swift
//  books
//
//  Created by Tyler Reed on 4/1/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var dbContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\Books.title, order: .forward)], predicate: nil, animation: .default)
    private var listOfBooks: FetchedResults<Books>
    
    @SectionedFetchRequest(sectionIdentifier: \Books.author?.name, sortDescriptors: [SortDescriptor(\Books.author?.name, order: .forward)], predicate: nil, animation: .default)
    private var sectionBooks: SectionedFetchResults<String?, Books>
    
    @State private var search: String = ""
    @State private var totalBooks: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Total Books")
                    Spacer()
                    Text("\(totalBooks)")
                        .bold()
                }
                .foregroundColor(.green)
                
//                ForEach(listOfBooks) { book in
//                    NavigationLink(destination: AuthorBooksView(selectedAuthor: book.author), label: {
//                        RowBook(book: book)
//                            .id(UUID())
//                    })
//                }
//                .onDelete(perform: { indexes in
//                    Task(priority: .high) {
//                        await deleteBook(indexes: indexes)
//                    }
//                })
                ForEach(sectionBooks) { section in
                    Section(header: Text(section.id ?? "Undefined")) {
                        ForEach(section) { book in
                            NavigationLink(destination: ModifyBookView(book: book), label: {
                                RowBook(book: book)
                                    .id(UUID())
                            })
                        }
                    }
                }
            }
            .navigationBarTitle("Books")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Sort") {
                        Button("Sort by Title") {
                            let sort = SortDescriptor(\Books.title, order: .forward)
                            listOfBooks.sortDescriptors = [sort]
                        }
                        Button("Sort by Author") {
                            let sort = SortDescriptor(\Books.author?.name, order: .forward)
                            listOfBooks.sortDescriptors = [sort]
                        }
                        Button("Sort by Year") {
                            let sort = SortDescriptor(\Books.year, order: .forward)
                            listOfBooks.sortDescriptors = [sort]
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: InsertBookView(), label: {
                        Image(systemName: "plus")
                    })
                }
            }
            // navigationBarDrawer displaymode always has the search bar shown, otherwise you have to pull down
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search by Title"))
            .onChange(of: search) { value in
                if !value.isEmpty {
                    listOfBooks.nsPredicate = NSPredicate(format: "title CONTAINS[dc]%@", value)
                } else {
                    listOfBooks.nsPredicate = nil
                }
            }
            .onAppear {
                countBooks()
            }
        }
    }
    
    func deleteBook(indexes: IndexSet) async {
        await dbContext.perform {
            for index in indexes {
                dbContext.delete(listOfBooks[index])
                countBooks()
            }
            do {
                try dbContext.save()
            } catch {
                print("Error deleting object(s).")
            }
        }
    }
    
    // I use the .count method because it consumes less resources
    // it returns an Int with the number of objects we WOULD get if we called the fetch() method
    func countBooks() {
        let request: NSFetchRequest<Books> = Books.fetchRequest()
        if let count = try? self.dbContext.count(for: request) {
            totalBooks = count
        }
    }
}

struct RowBook: View {
    let book: Books
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: book.showThumbnail)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 100)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(book.showTitle)
                    .bold()
                Text(book.showAuthor)
                Text(book.showYear)
                    .font(.caption)
                
                Spacer()
            }
            .padding(.top, 5)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  Book.swift
//  books
//
//  Created by Tyler Reed on 4/1/22.
//

import SwiftUI

struct Book: Codable {
    var title: String
    var author: Author
    var year: Int
    var cover: String?
    var thumbnail: String?
}

struct Author: Codable {
    var name: String
}

struct BookViewModel: Identifiable {
    let id: UUID = UUID()
    var book: Book
    
    var title: String {
        return book.title.capitalized
    }
    
    var author: String {
        return book.author.name.capitalized
    }
    
    var year: String {
        return String(book.year)
    }
    
    var cover: UIImage {
        if let imageName = book.cover {
            let manager = FileManager.default
            let docURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageURL = docURL.appendingPathComponent(imageName)
            let path = imageURL.path
            
            if let coverImage = UIImage(contentsOfFile: path) {
                return coverImage
            }
        }
        
        return UIImage(named: "nopicture")!
    }
}

//class ApplicationData: ObservableObject {
//    @Published var bookInFile: BookViewModel
//
//    var manager: FileManager
//    var docURL: URL
//
//    init() {
//        manager = FileManager.default
//        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask)
//        docURL = documents.first!
//        bookInFile = BookViewModel(
//            book: Book(
//                title: "",
//                author: "",
//                year: 0,
//                cover: nil
//            )
//        )
//
//        let fileURL = docURL.appendingPathComponent("userdata.dat")
//        let path = fileURL.path
//        if manager.fileExists(atPath: path) {
//            if let content = manager.contents(atPath: path) {
//                let decoder = PropertyListDecoder()
//
//                if let book = try? decoder.decode(Book.self, from: content) {
//                    bookInFile.book = book
//                }
//            }
//        }
//    }
//
//    func saveBook(book: Book) {
//        let fileURL = docURL.appendingPathComponent("userdata.dat")
//        let path = fileURL.path
//        let encoder = PropertyListEncoder()
//        if let data = try? encoder.encode(book) {
//            if manager.createFile(atPath: path, contents: data, attributes: nil) {
//                bookInFile = BookViewModel(book: book)
//            }
//        }
//    }
//}

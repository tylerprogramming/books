//
//  DetailView.swift
//  books
//
//  Created by Tyler Reed on 4/2/22.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    // when the object gets updated in the ModifyBookView, this gets updated as well because we
    // are observing it!  FINALLY it makes a little sense
    @ObservedObject var book: Books
    
    @State private var showEditView = false
    
    var body: some View {
        VStack {
            Text(book.showTitle)
            Text(book.showYear)
            
            NavigationLink(destination: ModifyBookView(book: book), label: {
                Text("Next!")
            })
            
        }
        .padding(.all)
        .navigationTitle(book.showTitle)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showEditView.toggle()
                }
            }
        }
        .sheet(isPresented: $showEditView) {
            NavigationView {
                ModifyBookView(book: book)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showEditView = false
                            }
                        }
                    }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
                
//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}

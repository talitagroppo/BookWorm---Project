//
//  ContentView.swift
//  BookWorm - Project
//
//  Created by Talita Groppo on 03/03/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true), NSSortDescriptor(keyPath: \Book.author, ascending: true)]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false
    @State private var selectColor = Color.red
    
    var body: some View {
        NavigationView {
        List {
            ForEach(books, id: \.self) { book in
                NavigationLink(destination: DetailView(book: book)){
                    EmojiRatingView(rating: book.rating)
                        .font(.largeTitle)

                    VStack(alignment: .leading) {
                        Text(book.title ?? "Unknown Title")
                            .font(.headline)
                        Text(book.author ?? "Unknown Author")
                            .foregroundColor(book.rating < 2 ? .red : .primary)
                    }
                }
            }
            .onDelete(perform: deleteBooks)
        }
                .navigationBarTitle("Bookworm")
        .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                        .padding(5)
                        .background(Color.clear)
                        .clipShape(Circle())
                }
        )
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView().environment(\.managedObjectContext, self.moc)
                }
        }
    }
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                return ContentView().environment(\.managedObjectContext, context)
    }
}

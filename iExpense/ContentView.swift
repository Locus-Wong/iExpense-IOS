//
//  ContentView.swift
//  iExpense
//
//  Created by Locus Wong on 2026-01-26.
//

import SwiftUI

@Observable
class User {
    var firstName = "Bilbo"
    var lastName = "Baggins"
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button("Dismiss"){
            dismiss()
        }
    }
}

struct ContentView: View {
    @State private var user = User()
    @State private var showingSheet = false
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
            Button("Show Sheet"){
                showingSheet.toggle()
            }
        }
        .sheet(isPresented: $showingSheet){
           SecondView()
        }
    }
}

#Preview {
    ContentView()
}

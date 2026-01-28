//
//  ContentView.swift
//  iExpense
//
//  Created by Locus Wong on 2026-01-26.
//

import SwiftUI

struct ExpenseItem {
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expense{
    var items = [ExpenseItem]()
}

struct ContentView: View {
    @State private var expenses = Expense()
    var body: some View{
        NavigationStack{
            List{
                ForEach(expenses.items, id: \.name){item in Text(item.name)}
                    .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button("Add Expense", systemImage: "plus"){
                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    expenses.items.append(expense)
                }
            }
        }
    }

    func removeItems(at offset: IndexSet){
        expenses.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  iExpense
//
//  Created by Locus Wong on 2026-01-26.
//

import SwiftUI

struct ExpenseItem : Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable class Expenses{
    var items = [ExpenseItem](){
        didSet{
            if let encoded = try? JSONEncoder().encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var personalExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Personal" }
    }
    
    var businessExpenses: [ExpenseItem] {
        expenses.items.filter { $0.type == "Business" }
    }
    
    var body: some View{
        NavigationStack{
            List{
                if !personalExpenses.isEmpty {
                    Section("Personal") {
                        ForEach(personalExpenses) { item in
                            ExpenseRow(item: item)
                        }
                        .onDelete { offsets in
                            removeItems(at: offsets, from: personalExpenses)
                        }
                    }
                }
                
                if !businessExpenses.isEmpty {
                    Section("Business") {
                        ForEach(businessExpenses) { item in
                            ExpenseRow(item: item)
                        }
                        .onDelete { offsets in
                            removeItems(at: offsets, from: businessExpenses)
                        }
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar{
                Button("Add Expense", systemImage: "plus"){
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense){
                AddView(expenses: expenses)
            }
        }
    }
    
    // Example showing the problem (The offsets are indices from the filtered array, not the main array):
    //    expenses.items = [
    //        0: Coffee (Personal)
    //        1: Laptop (Business)
    //        2: Lunch (Personal)
    //        3: Phone (Business)
    //    ]
    //
    //    personalExpenses = [
    //        0: Coffee
    //        1: Lunch
    //    ]
    func removeItems(at offsets: IndexSet, from filteredItems: [ExpenseItem]) {
        // Find the actual indices in the main array
        let idsToDelete = offsets.map { filteredItems[$0].id }
        expenses.items.removeAll { item in
            idsToDelete.contains(item.id)
        }
    }
}

struct ExpenseRow: View {
    let item: ExpenseItem
    
    var amountColor: Color {
        switch item.amount {
        case 0...20:
            return .green
        case 20...50:
            return .yellow
        case 50..<100:
            return .orange
        default:
            return .red
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
                    .font(.footnote)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(amountColor)
        }
    }
}

#Preview {
    ContentView()
}

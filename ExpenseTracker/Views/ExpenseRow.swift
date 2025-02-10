import SwiftUI

struct ExpenseRow: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title ?? "")
                    .font(.headline)
                Text(expense.category ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("¥\(String(format: "%.2f", expense.amount))")
                .font(.headline)
                .foregroundColor(expense.amount < 0 ? .red : .green)
        }
        .padding(.vertical, 4)
    }
} 
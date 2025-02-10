import SwiftUI
import SwiftData

struct AddBudgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var category = "日常支出"
    @State private var amount = ""
    @State private var period = "monthly"
    
    let categories = ["日常支出", "餐饮", "交通", "购物", "娱乐", "其他"]
    let periods = ["monthly": "每月", "yearly": "每年"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("类别", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("金额", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("周期", selection: $period) {
                        ForEach(periods.sorted(by: { $0.0 < $1.0 }), id: \.key) { key, value in
                            Text(value).tag(key)
                        }
                    }
                }
            }
            .navigationTitle("添加预算")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveBudget()
                }
            )
        }
    }
    
    private func saveBudget() {
        let newBudget = Budget(
            category: category,
            amount: Double(amount) ?? 0,
            period: period
        )
        modelContext.insert(newBudget)
        dismiss()
    }
} 
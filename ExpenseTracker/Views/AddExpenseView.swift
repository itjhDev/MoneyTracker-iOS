import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var amount = ""
    @State private var category = "日常支出"
    @State private var note = ""
    @State private var date = Date()
    @State private var isIncome = false
    
    let categories = ["日常支出", "餐饮", "交通", "购物", "娱乐", "其他"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("标题", text: $title)
                    
                    TextField("金额", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("日期", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("类型", selection: $isIncome) {
                        Text("支出").tag(false)
                        Text("收入").tag(true)
                    }
                    
                    Picker("类别", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("备注", text: $note)
                }
            }
            .navigationTitle("添加记录")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    saveExpense()
                }
            )
        }
    }
    
    private func saveExpense() {
        let newExpense = Expense(
            amount: Double(amount) ?? 0,
            date: date,
            title: title,
            category: category,
            note: note,
            isIncome: isIncome
        )
        modelContext.insert(newExpense)
        dismiss()
    }
} 
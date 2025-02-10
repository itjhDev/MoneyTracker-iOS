import SwiftUI
import SwiftData

struct BudgetSettingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Budget.category) private var budgets: [Budget]
    @State private var showingAddBudget = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(budgets) { budget in
                    BudgetRow(budget: budget)
                }
                .onDelete(perform: deleteBudget)
            }
            .navigationTitle("预算设置")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddBudget = true }) {
                        Label("添加预算", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView()
            }
        }
    }
    
    private func deleteBudget(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(budgets[index])
            }
        }
    }
}

struct BudgetRow: View {
    let budget: Budget
    @State private var progress: Double = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(budget.category ?? "未分类")
                    .font(.headline)
                Spacer()
                Text("¥\(String(format: "%.2f", budget.amount))")
                    .font(.subheadline)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                .onAppear {
                    // 计算预算使用进度
                    calculateProgress()
                }
            
            Text("已使用: \(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    private var progressColor: Color {
        if progress < 0.7 {
            return .green
        } else if progress < 0.9 {
            return .yellow
        } else {
            return .red
        }
    }
    
    private func calculateProgress() {
        // 这里需要实现计算预算使用进度的逻辑
        // 可以根据当前日期和支出记录计算
        progress = 0.75 // 示例值
    }
} 
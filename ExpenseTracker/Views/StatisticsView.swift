import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedPeriod = "月"
    let periods = ["周", "月", "年"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 时间段选择器
                    Picker("统计周期", selection: $selectedPeriod) {
                        ForEach(periods, id: \.self) { period in
                            Text(period).tag(period)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // 总支出卡片
                    TotalExpenseCard(amount: calculateTotalExpense())
                    
                    // 分类饼图
                    CategoryPieChart(expenses: expenses)
                    
                    // 支出趋势图
                    ExpenseTrendChart(expenses: expenses)
                }
            }
            .navigationTitle("支出统计")
        }
    }
    
    private func calculateTotalExpense() -> Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}

struct TotalExpenseCard: View {
    let amount: Double
    
    var body: some View {
        VStack {
            Text("总支出")
                .font(.headline)
            Text("¥\(String(format: "%.2f", amount))")
                .font(.largeTitle)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct CategoryPieChart: View {
    let expenses: [Expense]
    
    var categoryData: [(String, Double)] {
        Dictionary(grouping: expenses) { $0.category ?? "其他" }
            .mapValues { expenses in
                expenses.reduce(0) { $0 + $1.amount }
            }
            .map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
    }
    
    var body: some View {
        VStack {
            Text("支出分类")
                .font(.headline)
            
            // 使用 SwiftUI Charts 创建饼图
            Chart {
                ForEach(categoryData, id: \.0) { category in
                    SectorMark(
                        angle: .value("金额", category.1),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("类别", category.0))
                }
            }
            .frame(height: 200)
            
            // 图例
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(categoryData, id: \.0) { category in
                    HStack {
                        Circle()
                            .fill(Color.blue) // 这里应该对应饼图的颜色
                            .frame(width: 10, height: 10)
                        Text(category.0)
                        Text("¥\(String(format: "%.2f", category.1))")
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct ExpenseTrendChart: View {
    let expenses: [Expense]
    
    var body: some View {
        VStack {
            Text("支出趋势")
                .font(.headline)
            
            Chart {
                ForEach(groupExpensesByDate()) { data in
                    LineMark(
                        x: .value("日期", data.date),
                        y: .value("金额", data.amount)
                    )
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func groupExpensesByDate() -> [ExpenseData] {
        let grouped = Dictionary(grouping: expenses) { expense in
            Calendar.current.startOfDay(for: expense.date ?? Date())
        }
        return grouped.map { date, expenses in
            ExpenseData(
                date: date,
                amount: expenses.reduce(0) { $0 + $1.amount }
            )
        }.sorted { $0.date < $1.date }
    }
}

struct ExpenseData: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
} 
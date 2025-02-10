import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            ExpenseListView()
                .tabItem {
                    Label("支出", systemImage: "list.bullet")
                }
            
            CalendarView()
                .tabItem {
                    Label("日历", systemImage: "calendar")
                }
            
            StatisticsView()
                .tabItem {
                    Label("统计", systemImage: "chart.pie")
                }
            
            BudgetSettingView()
                .tabItem {
                    Label("预算", systemImage: "creditcard")
                }
            
            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
        }
    }
}

#Preview {
    let schema = Schema([
        Expense.self,
        Budget.self
    ])
    let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])
    
    return ContentView()
        .modelContainer(container)
} 
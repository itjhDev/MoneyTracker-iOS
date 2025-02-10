import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    let container: ModelContainer
    
    init() {
        do {
            // 创建 Schema
            let schema = Schema([
                Expense.self,
                Budget.self
            ])
            
            // 创建配置
            let modelConfiguration = ModelConfiguration(
                "MoneyTracker",
                schema: schema,
                url: URL.documentsDirectory.appendingPathComponent("MoneyTracker.store"),
                allowsSave: true
            )
            
            // 初始化容器
            container = try ModelContainer(
                for: schema,
                migrationPlan: nil,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
} 
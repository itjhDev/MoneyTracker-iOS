import SwiftUI

struct SettingsView: View {
    @AppStorage("currency") private var currency = "¥"
    @State private var showingExportSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("通用设置")) {
                    Picker("货币", selection: $currency) {
                        Text("¥").tag("¥")
                        Text("$").tag("$")
                        Text("€").tag("€")
                    }
                }
                
                Section(header: Text("数据管理")) {
                    Button("导出数据") {
                        exportData()
                    }
                    
                    Button("备份数据") {
                        backupData()
                    }
                }
                
                Section(header: Text("关于")) {
                    Text("版本 1.0.0")
                    Link("反馈问题", destination: URL(string: "https://github.com/itjhDev/MoneyTracker-iOS/issues")!)
                }
            }
            .navigationTitle("设置")
        }
    }
    
    private func exportData() {
        // 实现数据导出逻辑
        showingExportSheet = true
    }
    
    private func backupData() {
        // 实现数据备份逻辑
    }
} 
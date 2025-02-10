import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query(sort: \Expense.date) private var expenses: [Expense]
    @State private var selectedDate = Date()
    @State private var showingDayDetail = false
    
    private let calendar = Calendar.current
    private let daysInWeek = ["日", "一", "二", "三", "四", "五", "六"]
    
    var body: some View {
        NavigationView {
            VStack {
                // 月份选择器
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Text(monthYearString(from: selectedDate))
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: nextMonth) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()
                
                // 星期标题
                HStack {
                    ForEach(daysInWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // 日历网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(daysInMonth(), id: \.self) { date in
                        DayCell(date: date, 
                               selectedDate: $selectedDate,
                               dailyAmount: dailyAmount(for: date))
                            .onTapGesture {
                                selectedDate = date
                                showingDayDetail = true
                            }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("收支日历")
            .sheet(isPresented: $showingDayDetail) {
                DayDetailView(date: selectedDate)
            }
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        return formatter.string(from: date)
    }
    
    private func previousMonth() {
        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
    }
    
    private func nextMonth() {
        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
    }
    
    private func daysInMonth() -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let prefixDays = firstWeekday - 1
        
        return (-prefixDays..<(range.count)).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: firstDay)
        }
    }
    
    private func dailyAmount(for date: Date) -> Double {
        let dayStart = calendar.startOfDay(for: date)
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? date
        
        return expenses.filter { expense in
            expense.date >= dayStart && expense.date < dayEnd
        }.reduce(0) { sum, expense in
            sum + (expense.isIncome ? expense.amount : -expense.amount)
        }
    }
}

struct DayCell: View {
    let date: Date
    @Binding var selectedDate: Date
    let dailyAmount: Double
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            Text("\(calendar.component(.day, from: date))")
                .foregroundColor(isToday ? .white : .primary)
                .frame(width: 30, height: 30)
                .background(isToday ? Color.blue : Color.clear)
                .clipShape(Circle())
            
            if dailyAmount != 0 {
                Text(String(format: "%.0f", abs(dailyAmount)))
                    .font(.caption)
                    .foregroundColor(dailyAmount > 0 ? .green : .red)
            }
        }
        .frame(height: 50)
        .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
}

struct DayDetailView: View {
    let date: Date
    @Query private var expenses: [Expense]
    @Environment(\.dismiss) private var dismiss
    
    init(date: Date) {
        self.date = date
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        let predicate = #Predicate<Expense> { expense in
            expense.date >= startDate && expense.date < endDate
        }
        
        // 初始化 @Query
        _expenses = Query(
            filter: predicate,
            sort: [SortDescriptor(\Expense.date)]
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses) { expense in
                    ExpenseRow(expense: expense)
                }
            }
            .navigationTitle(formattedDate)
            .navigationBarItems(trailing: Button("完成") {
                dismiss()
            })
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter.string(from: date)
    }
} 
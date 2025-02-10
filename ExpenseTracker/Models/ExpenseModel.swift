import Foundation
import SwiftData

@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var amount: Double
    var date: Date
    var title: String
    var category: String
    var note: String
    var isIncome: Bool  // 添加收入/支出标识
    
    init(id: UUID = UUID(), 
         amount: Double, 
         date: Date = Date(), 
         title: String, 
         category: String, 
         note: String = "",
         isIncome: Bool = false) {
        self.id = id
        self.amount = amount
        self.date = date
        self.title = title
        self.category = category
        self.note = note
        self.isIncome = isIncome
    }
}

@Model
final class Budget {
    @Attribute(.unique) var id: UUID
    var category: String
    var amount: Double
    var period: String
    var startDate: Date
    var endDate: Date?
    
    init(id: UUID = UUID(), 
         category: String, 
         amount: Double, 
         period: String, 
         startDate: Date = Date()) {
        self.id = id
        self.category = category
        self.amount = amount
        self.period = period
        self.startDate = startDate
    }
} 
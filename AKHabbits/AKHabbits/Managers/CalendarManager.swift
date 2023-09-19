//
//  CalendarManager.swift
//  AKHabbits
//
//  Created by Анна Перехрест  on 2023/09/19.
//

import Foundation

class CalendarManager: ObservableObject {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    @Published var selectedDate = Date.now
    
    
    func getMonthYearFormatterString() -> String {
        dateFormatter.dateFormat = "MMMM YYYY"
        
        return dateFormatter.string(from: selectedDate)
    }
    
    
    func getDayFormatterString(_ day: Date) -> String {
        dateFormatter.dateFormat = "d"
        
        return dateFormatter.string(from: selectedDate)
    }
    
    
    func getWeekDayFormatterString(_ day: Date) -> String {
        dateFormatter.dateFormat = "EEEEE"
        
        return dateFormatter.string(from: selectedDate)
    }
    
    func getFullDateFormatterString() -> String {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: selectedDate)
    }
    
    
    
    
    
    func nextMonth() {
        guard let next = calendar.date(byAdding: .month, value: 1, to: selectedDate) else {
            return
        }
        
        selectedDate = next
    }
    
    func previouseMonth() {
        guard let previouse = calendar.date(byAdding: .month, value: -1, to: selectedDate) else {
            return
        }
        
        selectedDate = previouse
    }
    
    func daysInMonth(for date: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
    
    func isSameDay(_ date: Date) -> Bool {
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }
}

 extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]

        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }

            guard date < dateInterval.end else {
                stop = true
                return
            }

            dates.append(date)
        }

        return dates
    }

    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

//extension CalendarViewComponent: Equatable {
//    public static func == (lhs: CalendarViewComponent<Day, Header, Title, Trailing>, rhs: CalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
//        lhs.calendar == rhs.calendar && lhs.date == rhs.date
//    }
//}

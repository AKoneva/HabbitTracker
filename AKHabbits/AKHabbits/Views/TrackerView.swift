//
//  ContentView.swift
//  AKHabbits
//
//  Created by Анна Перехрест  on 2023/09/19.
//

import SwiftUI


struct CalendarViewComponent<Day: View, Header: View, Title: View, Trailing: View>: View, Equatable {
    @Environment(\.colorScheme) var colorScheme
    
    // Injected dependencies
    private var manager: CalendarManager
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    
    // Constants
    private let daysInWeek = 7
    
    public init(
        manager: CalendarManager,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
        self.manager = manager
        self.content = content
        self.trailing = trailing
        self.header = header
        self.title = title
    }
    
    public var body: some View {
        let month = manager.selectedDate.startOfMonth(using: manager.calendar)
        let days = manager.daysInMonth(for: manager.selectedDate)
        
        VStack {
            
            Section(header: title(month)) { }
            
            VStack {
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                }
                
                Divider()
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
                    ForEach(days, id: \.self) { date in
                        if manager.calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date)
                        } else {
                            trailing(date)
                        }
                    }
                }
            }
            .frame(height: days.count == 42 ? 300 : 270)
            .shadow(color: colorScheme == .dark ? .white.opacity(0.4) : .black.opacity(0.35), radius: 5)
            
            //            List(entries) { entry in
            //                NavigationLink {
            //                    CalendarDetailView(entry: entry)
            //                } label: {
            //                    CalendarCardView(entry: entry)
            //                }
            //            }.listStyle(.plain)
        }
    }
    
    static func == (lhs: CalendarViewComponent<Day, Header, Title, Trailing>, rhs: CalendarViewComponent<Day, Header, Title, Trailing>) -> Bool {
        return lhs.manager.calendar == rhs.manager.calendar && lhs.manager.selectedDate == rhs.manager.selectedDate
        }
}


struct CallendarButon: View {
    @ObservedObject var calendarManager: CalendarManager
    
    @State var date: Date
    
    var body: some View {
        Button(action: { calendarManager.selectedDate = date }) {
            Text(calendarManager.getDayFormatterString(date))
                .padding(6)
                .frame(width: 33, height: 33)
                .foregroundColor(calendarManager.calendar.isDateInToday(date) ? Color.white : .primary)
                .background(
                    calendarManager.calendar.isDateInToday(date) ? Color.blue : .clear
                )
                .cornerRadius(10)
        }
    }
}


struct TrackerView: View {
    @ObservedObject var calendarManager = CalendarManager()
    
    //    var body: some View {
    //        VStack {
    ////            Text(calendarManager.getFullDateString())
    //            MonthSlider()
    //            LazyVGrid(columns: Array(repeating: GridItem(), count: 1)) {
    //                ForEach(calendarManager.daysInMonth(), id: \.self) { day in
    ////                    Text(calendarManager.formateDayString(day))
    ////                    Text(calendarManager.getFullDateString(day: day))
    ////                        .frame(minWidth: 0, maxWidth: .infinity)
    ////                        .frame(height: 40)
    ////                        .background(calendarManager.isSameDay(day) ? Color.blue : Color.clear)
    ////                        .cornerRadius(8)
    ////                        .onTapGesture {
    ////                            print(day)
    ////                            calendarManager.selectedDate = day
    ////                        }
    //                }
    //
    //            }
    //        }
    //        .padding()
    //    }
    //}
    
    
    
    var body: some View {
        VStack {
            Text(calendarManager.getFullDateFormatterString())
            CalendarViewComponent(
                manager: calendarManager,
                content: { date in
                    ZStack {
                        CallendarButon(calendarManager: calendarManager, date: date)
                    }
                },
                trailing: { date in
                    Text(calendarManager.getDayFormatterString(date))
                        .foregroundColor(.secondary)
                },
                header: { date in
                    Text(calendarManager.getWeekDayFormatterString(date)).fontWeight(.bold)
                },
                title: { date in
                    MonthSlider(calendarManager: calendarManager)
                }
            )
            .equatable()
        }
    }
}


struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView()
    }
}

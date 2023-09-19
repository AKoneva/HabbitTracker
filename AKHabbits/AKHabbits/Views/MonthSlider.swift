//
//  MonthSlider.swift
//  AKHabbits
//
//  Created by Анна Перехрест  on 2023/09/19.
//

import SwiftUI

struct MonthSlider: View {
    @ObservedObject var calendarManager: CalendarManager
    
    var body: some View {
        HStack {
            Button(action: previousMonth) {
                Label(
                    title: { Text("Previous") },
                    icon: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                )
                .labelStyle(IconOnlyLabelStyle())
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button {
                calendarManager.selectedDate = Date.now
            } label: {
                Text(calendarManager.getMonthYearFormatterString())
                    .foregroundColor(.blue)
                    .font(.title2)
                    .padding(2)
            }
            
            Spacer()
            
            Button(action: nextMonth) {
                Label(
                    title: { Text("Next") },
                    icon: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                        
                    }
                )
                .labelStyle(IconOnlyLabelStyle())
                .padding(.horizontal)
            }
        }
    }
    
    func previousMonth() {
        calendarManager.previouseMonth()
    }
    
    func nextMonth() {
        calendarManager.nextMonth()
    }
}

struct MonthSlider_Previews: PreviewProvider {
    static var previews: some View {
        MonthSlider(calendarManager: CalendarManager())
    }
}

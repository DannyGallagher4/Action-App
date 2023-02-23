//
//  CalendarHeaderView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/3/23.
//

import SwiftUI

struct CalendarHeaderView: View {
    
    let lastSunday: Date
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    let daysInWeek = 7
    
    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    let monthNum: Int
    
    
    var body: some View {
        HStack {
            ForEach(0...6, id: \.self) { dayIdx in
                let weekdayLetter: String = daysOfWeek[dayIdx]
                let day: Int = Calendar.current.component(.day, from: lastSunday)
                let weekdayNumber: Int = day + dayIdx > daysInMonth[monthNum-1] ? day + dayIdx - daysInMonth[monthNum-1] : day + dayIdx
                
                VStack(spacing: 6) {
                    Text("\(weekdayLetter)")
                        .foregroundColor(.black)
                        .font(.caption)
                    
                    Text("\(weekdayNumber)")
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

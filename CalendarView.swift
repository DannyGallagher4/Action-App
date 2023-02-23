//
//  CalendarView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/2/23.
//

import SwiftUI

struct CalendarView: View {
//    @State var lastSunday: Date = {
//        let calendar = Calendar.current
//        let today = Date()
//        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: today)
//        components.weekday = 1
//        return calendar.date(from: components) ?? Date()
//    }()
//
//    @State var nextSunday: Date = {
//        let date = Date()
//        let calendar = Calendar.current
//        let nextSunday = calendar.nextDate(after: date, matching: .init(weekday: 1), matchingPolicy: .nextTime)
//
//        return nextSunday ?? Date()
//
//    }()
//
//    @State var month: String = {
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: Date())
//
//        let monthName = DateFormatter().monthSymbols[month-1]
//        return monthName
//    }()
//
//    @State var monthNum: Int = {
//        let date = Date()
//        let calendar = Calendar.current
//        let month = calendar.component(.month, from: date)
//        return month - 1
//    }()
//
//    @State var year: Int = {
//
//        let date = Date()
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date)
//        return year
//
//    }()
//
//    @State private var weeksForwardCounter = 0
//
//    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    @State var currentDate: Date = Date()
    
    var body: some View{
        
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 20){
                CustomDatePickerView(currentDate: $currentDate)
            }
            .padding(.vertical)
        }
        .safeAreaInset(edge: .bottom, content: {
            HStack{
                Button{
                    
                } label: {
                    Text("Add Event")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.ninjaYellow, in: Capsule())
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .background(.ultraThinMaterial)
        })
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
        
        
//        ZStack {
//            Color.ninjaBlue
//                .edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 10) {
//                Text("\(month) \(String(year))")
//                    .font(.title2)
//
//                HStack{
//
//                    Button(){
//
//                        weeksForwardCounter -= 1
//
//                        getNewDateValues()
//
//                    } label: {
//
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.black)
//
//                    }
//
//                    if(Calendar.current.component(.day, from: lastSunday) + 13 > daysInMonth[monthNum-1]){
//
//                        Text("\(Calendar.current.component(.day, from: lastSunday)) - \(Calendar.current.component(.day, from: lastSunday) + 13 - daysInMonth[monthNum-1])")
//                            .font(.title2)
//
//                    } else {
//
//                        Text("\(Calendar.current.component(.day, from: lastSunday)) - \(Calendar.current.component(.day, from: lastSunday) + 13)")
//                            .font(.title2)
//
//                    }
//
//                    Button(){
//
//                        weeksForwardCounter += 1
//
//                        getNewDateValues()
//
//                    } label: {
//
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.black)
//
//                    }
//
//                }
//                .padding(.top, 5)
//
//                CalendarHeaderView(lastSunday: lastSunday, monthNum: monthNum)
//
//                Divider()
//
//                CalendarHeaderView(lastSunday: nextSunday, monthNum: monthNum)
//
//                Spacer()
//            }
//            .navigationBarTitle("Calendar")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//
//    func getNewDateValues(){
//        let date = Date()
//        let calendar = Calendar.current
//        let newDate = calendar.date(byAdding: .weekOfYear, value: 2*weeksForwardCounter, to: date)
//
//        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: newDate!)
//        components.weekday = 1
//        lastSunday = calendar.date(from: components)!
//
//        nextSunday = calendar.nextDate(after: newDate!, matching: .init(weekday: 1), matchingPolicy: .nextTime)!
//
//        let monthTest = calendar.component(.month, from: lastSunday)
//
//        month = DateFormatter().monthSymbols[monthTest-1]
//
//        monthNum = calendar.component(.month, from: newDate!)
//        year = calendar.component(.year, from: newDate!)
//    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

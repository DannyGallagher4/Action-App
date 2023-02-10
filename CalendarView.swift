//
//  CalendarView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/2/23.
//

import SwiftUI

struct CalendarView: View {
    @State var lastSunday: Date = {
        let calendar = Calendar.current
        let today = Date()
        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: today)
        components.weekday = 1
        return calendar.date(from: components) ?? Date()
    }()
    
    @State var nextSunday: Date = {
        let date = Date()
        let calendar = Calendar.current
        let nextSunday = calendar.nextDate(after: date, matching: .init(weekday: 1), matchingPolicy: .nextTime)
        
        return nextSunday ?? Date()
        
    }()
    
    @State var month: String = {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: Date())

        let monthName = DateFormatter().monthSymbols[month-1]
        return monthName
    }()
    
    @State var monthNum: Int = {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        return month - 1
    }()
    
    @State var year: Int = {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return year
        
    }()
    
    @State private var weeksForwardCounter = 0
    
    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var body: some View{
        NavigationView{
            VStack{
                
                Text("\(month) \(year)")
                    .font(.title2)
                    .padding(.top, 100)
                
                HStack{
                    
                    Button(){
                        
                        weeksForwardCounter -= 1
                        let date = Date()
                        let calendar = Calendar.current
                        let newDate = calendar.date(byAdding: .weekOfYear, value: 2*weeksForwardCounter, to: date)
                        
                        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: newDate!)
                        components.weekday = 1
                        lastSunday = calendar.date(from: components)!
                        
                        nextSunday = calendar.nextDate(after: newDate!, matching: .init(weekday: 1), matchingPolicy: .nextTime)!
                        
                        let monthTest = calendar.component(.month, from: newDate!)

                        month = DateFormatter().monthSymbols[monthTest-1]
                        
                        monthNum = calendar.component(.month, from: newDate!)
                        
                        year = calendar.component(.year, from: newDate!)
                        
                    } label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                        
                    }
                    
                    if(Calendar.current.component(.day, from: lastSunday) + 13 > daysInMonth[monthNum-1]){
                        
                        Text("\(Calendar.current.component(.day, from: lastSunday)) - \(Calendar.current.component(.day, from: lastSunday) + 13 - daysInMonth[monthNum-1])")
                            .font(.title2)
                        
                    } else {
                        
                        Text("\(Calendar.current.component(.day, from: lastSunday)) - \(Calendar.current.component(.day, from: lastSunday) + 13)")
                            .font(.title2)
                        
                    }
                    
                    Button(){
                        
                        weeksForwardCounter += 1
                        let date = Date()
                        let calendar = Calendar.current
                        let newDate = calendar.date(byAdding: .weekOfYear, value: 2*weeksForwardCounter, to: date)
                        
                        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: newDate!)
                        components.weekday = 1
                        lastSunday = calendar.date(from: components)!
                        
                        nextSunday = calendar.nextDate(after: newDate!, matching: .init(weekday: 1), matchingPolicy: .nextTime)!
                        
                        let monthTest = calendar.component(.month, from: newDate!)

                        month = DateFormatter().monthSymbols[monthTest-1]
                        
                        monthNum = calendar.component(.month, from: newDate!)
                        year = calendar.component(.year, from: newDate!)
                        
                    } label: {
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                        
                    }
                    
                }
                .padding(.top, 5)
                
                VStack{
                    
                    CalendarHeaderView(lastSunday: lastSunday, monthNum: monthNum)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    CalendarHeaderView(lastSunday: nextSunday, monthNum: monthNum)
                    
                    Spacer()
                }
                
            }
            .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
            .ignoresSafeArea()
            .navigationBarTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

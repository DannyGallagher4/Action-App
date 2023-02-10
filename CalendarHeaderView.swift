//
//  CalendarHeaderView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/3/23.
//

import SwiftUI

struct CalendarHeaderView: View {
    
    //@State private var currentWeekNum = Calendar.current.component(.weekOfYear, from: Date())
    let lastSunday: Date
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    let daysInWeek = 7
    
    let daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    let monthNum: Int
    
    
    var body: some View {
        
        GeometryReader{ geo in
            
            VStack{
                
                HStack{
                    ForEach(daysOfWeek, id: \.self){day in
                        
                        Text(day)
                            .frame(width: geo.size.width/8)
                    }
                }
                
                HStack{
                    ForEach(0..<daysInWeek, id: \.self){num in
                        
                        if(Calendar.current.component(.day, from: lastSunday) + num > daysInMonth[monthNum-1]){
                            
                            Text("\(Calendar.current.component(.day, from: lastSunday) + num - daysInMonth[monthNum-1])")
                                .frame(width: geo.size.width/8)
                                .padding(.top, 5)
                            
                        } else {
                            
                            Text("\(Calendar.current.component(.day, from: lastSunday) + num)")
                                .frame(width: geo.size.width/8)
                                .padding(.top, 5)
                            
                        }
                    }
                }
                
//                Text("\(currentWeekNum)")
//                Text(lastSunday, style: .date)
                
            }
            .padding(.top, 20)
        }
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
        
    }
}

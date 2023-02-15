//
//  DayView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/13/23.
//

import SwiftUI

struct DayView: View {
    let dayOfWeek: Int
    let dayOfMonth: Int
    let eventsToday: [EventItem]
    
    let daysInWeek = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"]
    
    var body: some View {
        VStack{
            Text("\(daysInWeek[dayOfWeek])")
                .padding(.leading, 10)
                .padding(.top, 10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.ninjaYellow)
            //    .fontWeight(.bold)
            
            Text("\(dayOfMonth)")
                .padding(.leading, 10)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.ninjaYellow)
                .fontWeight(.bold)
                .font(.title)
            
            ForEach(eventsToday){ event in
                Text("\(event.name)")
            }
        }
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(dayOfWeek: 1, dayOfMonth: 16, eventsToday: [EventItem]())
    }
}

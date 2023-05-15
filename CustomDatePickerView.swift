//
//  CustomDatePickerView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/17/23.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore

struct CustomDatePickerView: View {
    @Binding var currentDate: Date
    
    @Binding var isCoach: Bool?
    
    @State private var currentMonth: Int = 0
    
    @State private var events = [EventMetaData]()
    
    @State private var showAlert = false
    
    @State private var eventToDelete: Event? = nil
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 35){
            
            let daysOfWeek = ["Sun", "Mon", "Tues", "Wed", "Thur", "Fri", "Sat"]
            
            HStack(spacing: 20){
                VStack(alignment: .leading, spacing: 10){
                    Text(extraDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraDate()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button{
                    currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button{
                    currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 0){
                ForEach(daysOfWeek, id: \.self){ day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(extractDate()){ value in
                    CardView(value: value)
                        .background(
                            Circle()
                                .offset(x: 0, y: -8)
                                .fill(.gray)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1:0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
            VStack(spacing: 15){
                Text("Events")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                   // .padding(.vertical, 20)
                
                if let event = events.first(where: {event in
                    return isSameDay(date1: event.eventDate, date2: currentDate)
                }){
                    
                    ForEach(event.event){ event in
                        HStack{
                            VStack(alignment: .leading, spacing: 10) {
                                
                                if  let isCoach = isCoach{
                                    if isCoach{
                                        Button("Delete"){
                                            eventToDelete = event
                                            showAlert = true
                                        }
                                        .padding(10)
                                        .background(.white)
                                        .foregroundColor(.red)
                                        .clipShape(Capsule())
                                        
                                    }
                                }
                                
                                Text("\(getTimeValue(date: event.start_date)) - \(getTimeValue(date: event.end_date))")
                                
                                Text(event.title)
                                    .font(.title2.bold())
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing){
                                ForEach(event.ageGroupsInvolved, id: \.self){group in
                                    Text("\(group)")
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            event.eventColor()
                                .cornerRadius(10)
                        )
                    }
                    
                } else {
                    Text("No Event Found")
                }
            }
            .padding()
            
        }
        .onChange(of: currentMonth){ newValue in
            currentDate = getCurrentMonth()
            getNewMonthEvents(date: currentDate)
        }
        .onAppear{
            getNewMonthEvents(date: currentDate)
        }
        .alert("Do You Want To Delete This Event?", isPresented: $showAlert) {
            Button("Yes"){
                if let eventTo = eventToDelete{
                    deleteEvent(event: eventTo)
                }
            }
            Button("No"){ }
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue)-> some View{
        VStack{
            if value.day != -1{
                if let event = events.first(where: { event in
                    return isSameDay(date1: event.eventDate, date2: value.date)
                }){
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: event.eventDate, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ForEach(event.event){ eventSpecific in
                        Circle()
                            .fill( eventSpecific.eventColor())
                            .frame(width: 8, height: 8)
                    }
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    
    func getTimeValue(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    func extraDate()->[String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth()->Date{
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate()->[DateValue]{
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday-1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
    
    func getNewMonthEvents(date: Date){
        events = [EventMetaData]()
        let calendar = Calendar.current
        let components = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date))
        let startDate = calendar.date(from: components)!
        let endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
        
        let query = db.collection("events")
            .whereField("start_date", isGreaterThan: startDate)
            .whereField("start_date", isLessThan: endDate)
        
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let title = data["title"] as? String ?? ""
                    let start_date = data["start_date"] as? Timestamp ?? Timestamp()
                    let end_date = data["end_date"] as? Timestamp ?? Timestamp()
                    
                    let ageGroups = data["age_groups"] as? Array ?? [String]()
                    let type = data["event_type"] as? String ?? ""
                    let newEvent = Event(id: document.documentID, title: title, start_date: start_date.dateValue(), end_date: end_date.dateValue(), ageGroupsInvolved: ageGroups, eventType: type)

                    for eventMeta in events{
                        if isSameDay(date1: eventMeta.eventDate, date2: start_date.dateValue()){
                            eventMeta.event.append(newEvent)
                            break
                        }
                    }
                    
                    events.append(EventMetaData(id: UUID().uuidString, event: [newEvent], eventDate: start_date.dateValue()))

                }
            }
        }
    }
    
    func deleteEvent(event: Event){
        let id = event.id
        
        db.collection("events").document("\(id)").delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}

struct CustomDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

extension Date{
    func getAllDates()->[Date]{
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
                
        return range.compactMap{ day -> Date in
            return calendar.date(byAdding: .day, value: day-1, to: startDate)!
            
        }
        
    }
}

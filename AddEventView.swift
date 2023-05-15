//
//  AddEventView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/15/23.
//

import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseCore
import FirebaseFirestore

struct AddEventView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var ageGroupsInvolved = Set<String>()
    @State private var eventType = "Practice"
    let items = ["Kids", "Mature Kids", "Pre-Teens", "Teens", "Young Adults"]
    let eventTypes = ["Practice", "Competition", "Other"]
    
    var body: some View {
        NavigationView{
                
            Form{
                Section("Event Title"){
                    TextField("Event Title", text: $name)
                }


                Section{
                    DatePicker("Date:", selection: $date, displayedComponents: [.date])
                    DatePicker("Start Time:", selection: $startTime, displayedComponents: [.hourAndMinute])
                    DatePicker("Finish Time:", selection: $endTime, displayedComponents: [.hourAndMinute])
                }

                Section("Age Groups Involved (Select All)"){
                    List {
                        ForEach(items, id: \.self) { item in
                            MultipleSelectionRow(title: item, isSelected: self.ageGroupsInvolved.contains(item)) {
                                if self.ageGroupsInvolved.contains(item) {
                                    self.ageGroupsInvolved.remove(item)
                                } else {
                                    self.ageGroupsInvolved.insert(item)
                                }
                            }
                        }
                    }
                }
                
                Section{
                    Picker("Event Type:", selection: $eventType) {
                        ForEach(eventTypes, id: \.self){event in
                            Text(event)
                        }
                    }
                }
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: saveNewEvent) {
                        Text("Save")
                    }
                }
            }
            .navigationTitle("Add New Event")
            .background(Color.ninjaBlue)
            
        }
        
    }
                    
    func isSameDay(date1: Date, date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func saveNewEvent() {
        let calendar = Calendar.current
        let start_date = date
        let end_date = date
        
        let hrStart = calendar.component(.hour, from: startTime)
        let minStart = calendar.component(.minute, from: startTime)
        let hrEnd = calendar.component(.hour, from: endTime)
        let minEnd = calendar.component(.minute, from: endTime)
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: start_date)
        components.hour = hrStart
        components.minute = minStart
        let newStart = calendar.date(from: components) ?? Date()
        
        var end_components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: end_date)
        end_components.hour = hrEnd
        end_components.minute = minEnd
        let newEnd = calendar.date(from: end_components) ?? Date()
        
        let arrayOfAgeGroups = ageGroupsInvolved.sorted(by: {$0 < $1})
        
        let db = Firestore.firestore()
        
        db.collection("events").document("\(UUID().uuidString)").setData([
            "title": name,
            "event_type": eventType,
            "start_date": newStart,
            "end_date": newEnd,
            "age_groups": arrayOfAgeGroups
        ])
        
        dismiss()
        
        //                    events.forEach{ eventMeta in
        //                        if isSameDay(date1: eventMeta.eventDate, date2: date){
        //                            eventMeta.event.append(Event(id: UUID().uuidString, title: name, start_date: newStart, end_date: newEnd, ageGroupsInvolved: arrayOfAgeGroups, eventType: eventType))
        //                            dismiss()
        //                        }
        //                    }
        //
        //                    events.append(EventMetaData(event: [Event(id: UUID().uuidString, title: name, start_date: newStart, end_date: newEnd, ageGroupsInvolved: arrayOfAgeGroups, eventType: eventType)], eventDate: date))
    }
}

struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(title)
                Spacer()
                if self.isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
    }
}

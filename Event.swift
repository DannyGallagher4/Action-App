//
//  Event.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/17/23.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore

struct Event: Identifiable{
    var id: String
    var title: String
    var start_date: Date
    var end_date: Date
    var ageGroupsInvolved: [String]
    var eventType: String
    func eventColor() -> Color{
        if eventType == "Practice"{
            return Color.ninjaYellow
        } else if eventType == "Competition" {
            return Color.pink
        } else {
            return Color.orange
        }
    }
    
}

class EventMetaData: Identifiable{
    var id: String
    var event: [Event]
    var eventDate: Date
    
    init(id: String = UUID().uuidString, event: [Event], eventDate: Date) {
        self.id = id
        self.event = event
        self.eventDate = eventDate
    }
}

func getSampleDate(offset: Int)->Date{
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var events = [EventMetaData]()

let db = Firestore.firestore()

func getNewMonthEvents(date: Date){
    events = [EventMetaData]()
    let calendar = Calendar.current
    let components = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date))
    let startDate = calendar.date(from: components)!
//    print(startDate)
    let endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
//    print(endDate)
    
    let query = db.collection("events")
        .whereField("start_date", isGreaterThan: startDate)
        .whereField("start_date", isLessThan: endDate)
    
    query.getDocuments() { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            for document in querySnapshot!.documents {
                let data = document.data()
                //print(data)
                let title = data["title"] as? String ?? ""
                let start_date = data["start_date"] as? Timestamp ?? Timestamp()
                let end_date = data["end_date"] as? Timestamp ?? Timestamp()
                
//                print(title)
//                print(start_date)
                
                
//                print(start_date)
//                print(end_date)
                
                let ageGroups = data["age_groups"] as? Array ?? [String]()
                let type = data["event_type"] as? String ?? ""
                let newEvent = Event(id: document.documentID, title: title, start_date: start_date.dateValue(), end_date: end_date.dateValue(), ageGroupsInvolved: ageGroups, eventType: type)
                //print(newEvent)

                for eventMeta in events{
                    if isSameDay(date1: eventMeta.eventDate, date2: start_date.dateValue()){
                       // print("SUIIII before")
                        eventMeta.event.append(newEvent)
                       // print("SUIIII")
                        break
                    }
                }
                
                //print("Messi b4")
                
                events.append(EventMetaData(id: UUID().uuidString, event: [newEvent], eventDate: start_date.dateValue()))
                
//                print("Messi after")
//                
//                print(events)

            }
        }
    }
}

func isSameDay(date1: Date, date2: Date)->Bool{
    let calendar = Calendar.current
    
    return calendar.isDate(date1, inSameDayAs: date2)
}


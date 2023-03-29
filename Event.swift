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

let db = Firestore.firestore()

func getNewMonthEvents(date: Date){
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
                var data = document.data()
                var title = data["title"] as? String ?? ""
                var start_date = data["start_date"] as? Date ?? Date()
                var end_date = data["end_date"] as? Date ?? Date()
                var ageGroups = data["age_groups"] as? Array ?? [String]()
                var type = data["event_type"] as? String ?? ""
                var newEvent = Event(id: document.documentID, title: title, start_date: start_date, end_date: end_date, ageGroupsInvolved: ageGroups, eventType: type)
                //events.append(newEvent)
            }
        }
    }
}

var events: [EventMetaData] = [
    EventMetaData(event: [
        Event(id: String(UUID()), title: "Practice for pre-teens", start_date: getSampleDate(offset: 1), end_date: getSampleDate(offset: 1), ageGroupsInvolved: ["Pre-Teens"], eventType: "Practice"),
        Event(id: String(UUID()), title: "Practice for teens", start_date: getSampleDate(offset: 1), end_date: getSampleDate(offset: 1), ageGroupsInvolved: ["Teens"], eventType: "Practice"),
        Event(id: String(UUID()), title: "Practice for young adults", start_date: getSampleDate(offset: 1), end_date: getSampleDate(offset: 1), ageGroupsInvolved: ["Young Adults"], eventType: "Practice")
    ], eventDate: getSampleDate(offset: 1)),
    EventMetaData(event: [
        Event(id: String(UUID()), title: "Practice for kids", start_date: getSampleDate(offset: -3), end_date: getSampleDate(offset: -3), ageGroupsInvolved: ["Kids"], eventType: "Practice"),
        Event(id: String(UUID()), title: "Practice for mature kids", start_date: getSampleDate(offset: -3), end_date: getSampleDate(offset: -3), ageGroupsInvolved: ["Mature Kids"]),
    ], eventDate: getSampleDate(offset: -3), eventType: "Practice"),
    EventMetaData(event: [
        Event(id: String(UUID()), title: "Meet against Vitality", start_date: getSampleDate(offset: 8), end_date: getSampleDate(offset: 8), ageGroupsInvolved: ["Kids", "Mature Kids", "Pre-Teens", "Teens", "Young Adults"]),
    ], eventDate: getSampleDate(offset: 8), eventType: "Competition"),
]

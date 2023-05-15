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

func isSameDay(date1: Date, date2: Date)->Bool{
    let calendar = Calendar.current
    
    return calendar.isDate(date1, inSameDayAs: date2)
}


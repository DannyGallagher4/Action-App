//
//  Event.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/17/23.
//

import SwiftUI

struct Event: Identifiable{
    var id = UUID().uuidString
    var title: String
    var hourStart: Int
    var hourEnd: Int
    var minuteStart: Int
    var minuteEnd: Int
    var startIsAM: Bool
    var endIsAM: Bool
    var ageGroupsInvolved: [String]
}

struct EventMetaData: Identifiable{
    var id = UUID().uuidString
    var event: [Event]
    var eventDate: Date
}

func getSampleDate(offset: Int)->Date{
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

var events: [EventMetaData] = [

    EventMetaData(event: [
        Event(title: "Practice for pre-teens", hourStart: 18, hourEnd: 20, minuteStart: 30, minuteEnd: 00, startIsAM: false, endIsAM: false, ageGroupsInvolved: ["Pre-Teens"]),
        Event(title: "Practice for teens", hourStart: 18, hourEnd: 20, minuteStart: 30, minuteEnd: 00, startIsAM: false, endIsAM: false, ageGroupsInvolved: ["Teens"]),
        Event(title: "Practice for young adults", hourStart: 18, hourEnd: 20, minuteStart: 30, minuteEnd: 00, startIsAM: false, endIsAM: false, ageGroupsInvolved: ["Young Adults"])
    ], eventDate: getSampleDate(offset: 1)),
    EventMetaData(event: [
        Event(title: "Practice for kids", hourStart: 18, hourEnd: 20, minuteStart: 30, minuteEnd: 00, startIsAM: false, endIsAM: false, ageGroupsInvolved: ["Kids"]),
        Event(title: "Practice for mature kids", hourStart: 18, hourEnd: 20, minuteStart: 30, minuteEnd: 00, startIsAM: false, endIsAM: false, ageGroupsInvolved: ["Mature Kids"]),
    ], eventDate: getSampleDate(offset: -3)),
    EventMetaData(event: [
        Event(title: "Meet against Vitality", hourStart: 18, hourEnd: 20, minuteStart: 30, minuteEnd: 00, startIsAM: false, endIsAM: false, ageGroupsInvolved: ["Kids", "Mature Kids", "Pre-Teens", "Teens", "Young Adults"]),
    ], eventDate: getSampleDate(offset: 8)),

]

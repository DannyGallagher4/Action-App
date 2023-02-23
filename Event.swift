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
    var time: Date = Date()
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
        Event(title: "Practice for pre-teens"),
        Event(title: "Practice for teens"),
        Event(title: "Practice for young adults")
    ], eventDate: getSampleDate(offset: 1)),
    EventMetaData(event: [
        Event(title: "Practice for kids"),
        Event(title: "Practice for mature kids"),
    ], eventDate: getSampleDate(offset: -3)),
    EventMetaData(event: [
        Event(title: "Meet against Vitality"),
    ], eventDate: getSampleDate(offset: 8)),

]

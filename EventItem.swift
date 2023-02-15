//
//  EventItem.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/13/23.
//

import Foundation

class EventItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let date: Date
    let ageGroupsInvolved: [String]
}

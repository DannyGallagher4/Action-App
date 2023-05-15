//
//  Message.swift
//  Action-App
//
//  Created by Danny Gallagher on 4/7/23.
//

import Foundation

struct Message: Identifiable, Codable{
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}

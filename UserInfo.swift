//
//  UserInfo.swift
//  Action-App
//
//  Created by Danny Gallagher on 11/30/22.
//

import SwiftUI

class User: ObservableObject, Codable{
    enum CodingKeys: CodingKey{
        case name, email, division, isCoach
    }
    
    static let divisions = ["Kids", "Mature Kids", "Pre-Teens", "Teens", "Young Adults"]
    
    @Published var name = ""
    @Published var email = ""
    @Published var division = 0
    @Published var isCoach = false
    
    init(){}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(division, forKey: .division)
        try container.encode(isCoach, forKey: .isCoach)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        division = try container.decode(Int.self, forKey: .division)
        isCoach = try container.decode(Bool.self, forKey: .isCoach)
    }
}

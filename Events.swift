//
//  Events.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/13/23.
//

import Foundation

class Events: ObservableObject{
    @Published var items = [EventItem](){
        didSet{
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init(){
        if let savedItems = UserDefaults.standard.data(forKey: "Items"){
            if let decodedItems = try? JSONDecoder().decode([EventItem].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
}

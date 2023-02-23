//
//  AddEventView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/15/23.
//

import SwiftUI

struct AddEventView: View {
    
//    @ObservedObject var events: Events
//    @Environment(\.dismiss) var dismiss
//    @State private var name = ""
//    @State private var date = Date()
//    @State private var ageGroupsInvolved = Set<String>()
//    let items = ["Kids", "Mature Kids", "Pre-Teens", "Teens", "Young Adults"]
    
    var body: some View {
        NavigationView{
                
                
//            Form{
//                Section("Event Title"){
//                    TextField("Event Title", text: $name)
//                }
//
//
//                Section{
//                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
//                }
//
//                Section("Age Groups Involved (Select All)"){
//                    List {
//                        ForEach(items, id: \.self) { item in
//                            MultipleSelectionRow(title: item, isSelected: self.ageGroupsInvolved.contains(item)) {
//                                if self.ageGroupsInvolved.contains(item) {
//                                    self.ageGroupsInvolved.remove(item)
//                                } else {
//                                    self.ageGroupsInvolved.insert(item)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Add New Event")
//            .background(Color.ninjaBlue)
        }
        
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

//
//  UserView.swift
//  Action-App
//
//  Created by Danny Gallagher on 11/30/22.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var user: User
    
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $user.name)
                TextField("E-Mail Address", text: $user.email)
                Picker("Child's Age Division", selection: $user.division){
                    ForEach(User.divisions.indices){
                        Text(User.divisions[$0])
                    }
                }
            }
        }
        .navigationBarTitle("Your Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User())
    }
}

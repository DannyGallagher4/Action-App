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
        ZStack{
            Color.blue
            Form{
                Section{
                    TextField("Name", text: $user.name)
                    TextField("E-Mail Address", text: $user.email)
                    Picker("Child's Age Division", selection: $user.division){
                        ForEach(User.divisions, id: \.self){ division in
                            Text(division)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 70)
        }
        .ignoresSafeArea()
        .navigationBarTitle("Your Information")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(user: User())
    }
}

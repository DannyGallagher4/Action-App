//
//  UserView.swift
//  Action-App
//
//  Created by Danny Gallagher on 11/30/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct UserView: View {
    
    @State private var showingSignOutAlert = false
    
    @Binding var showingMainView: Bool
    @Binding var showingLoginAndSignUpView: Bool
    
    @ObservedObject var currentUser: CurrentUser
    
    var body: some View {
            
        VStack{
            
            List{
                Section{
                    Text("User ID: \(currentUser.id)")
                    Text("E-mail: \(currentUser.email)")
                    //                    Picker("Child's Age Division", selection: $currentUser.division){
                    //                        ForEach(User.divisions, id: \.self){ division in
                    //                            Text(division)
                    //                        }
                    //                    }
                }
            }
            .scrollContentBackground(.hidden)
            .padding(.top, 70)
            .frame(maxHeight: 300)
            
            Button(){
                
                showingSignOutAlert = true
                
            } label: {
                Text("Sign Out")
                    .font(.title2)
                    .padding(20)
                    .foregroundColor(.black)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.top, 20)
            
            Spacer()
            
        }
        .alert("Would You Like To Sign Out?", isPresented: $showingSignOutAlert){
            HStack{
                
                Button("Sign Out"){
                    let firebaseAuth = Auth.auth()
                    do {
                      try firebaseAuth.signOut()
                        showingLoginAndSignUpView = true
                        showingMainView = false
                    } catch let signOutError as NSError {
                      print("Error signing out: %@", signOutError)
                    }

                }
                
                Button("Cancel"){
                    showingSignOutAlert = false
                }
            }
        }
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
        .ignoresSafeArea()
        .navigationBarTitle("Your Information")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

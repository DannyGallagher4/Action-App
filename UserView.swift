//
//  UserView.swift
//  Action-App
//
//  Created by Danny Gallagher on 11/30/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

struct UserView: View {
    
    @State private var showingSignOutAlert = false
    
    @Binding var showingMainView: Bool
    @Binding var showingLoginAndSignUpView: Bool
    
    @ObservedObject var currentUser: CurrentUser
    
    @State private var email: String? = ""
    @State private var isCoach: Bool? = nil
    
    var body: some View {
            
        VStack{
            
            List{
                Section{
                    Text("E-mail: \(email ?? "no email acquired")")
                }
                if isCoach == true{
                    Section{
                        HStack{
                            Text("Coach Account")
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
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
                    
                    do {
                        try FirebaseManager.shared.auth.signOut()
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
        .onAppear {
            let uid = FirebaseManager.shared.currentUser?.uid ?? ""
            
            let db = Firestore.firestore()
            
            let docRef = db.collection("users").document(uid)
            
            docRef.getDocument { (document, error) in
                if let error = error{
                    print(error)
                    self.isCoach = false
                    self.email = ""
                } else {
                    if let document = document, document.exists {
                        let data = document.data()
                        self.isCoach = data?["isCoach"] as? Bool
                        self.email = data?["email"] as? String
                    }
                }
            }
        }
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
        .ignoresSafeArea()
        .navigationTitle("Your Information")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

//
//  MainView.swift
//  Action-App
//
//  Created by Danny Gallagher on 1/9/23.
//

import SwiftUI

struct ageModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding(5)
            .foregroundColor(.black)
            .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct MainView: View {
    @State private var ageGroup = "Kids"
    @State private var kidsOrMKs = true
    @AppStorage("finishes") private var podiumFinishes = 0
    
    @Binding var showingMainView: Bool
    @Binding var showingLoginAndSignUpView: Bool
    
    @ObservedObject var currentUser: CurrentUser
    
    var practiceTimesPreTeensAndUp: some View{
        VStack{
            Text("Tuesday 6:30-8:00")
            Text("Thursday 6:30-8:00")
        }
    }
    
    var practiceTimesKidsOrMKS: some View{
        VStack{
            Text("Monday 5:30-7:00")
            Text("Thursday 6:30-8:00")
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.ninjaBlue
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Image("action-athletics-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(10)
                    
                    NavigationLink{
                        
                        GroupChatLogView()
                        
                    } label: {
                        HStack{
                            Text("Group chat log").fontWeight(.bold)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                    }
                    
                    NavigationLink{
                        
                        UserView(showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView, currentUser: currentUser)
                        
                    } label: {
                        HStack{
                            Text("Account Information").fontWeight(.bold)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                    }
                    
                    NavigationLink{
                        CalendarView()
                    } label: {
                        HStack{
                            Text("Calendar").fontWeight(.bold)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                    }
                    
                    NavigationLink{
                        MainMessagesView()
                    } label: {
                        HStack{
                            Text("Messages").fontWeight(.bold)
                        }
                        .padding()
                        .foregroundColor(.black)
                        .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                }
                .padding(20)
                .background(Color.ninjaBlue)
                .navigationTitle("Home")
            }
        }
        .accentColor(.black)
        
    }
}

struct Previews_MainView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

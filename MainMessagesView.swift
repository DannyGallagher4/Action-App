//
//  MainMessagesView.swift
//  Action-App
//
//  Created by Danny Gallagher on 4/12/23.
//

import SwiftUI

struct MainMessagesView: View {
    
    @ObservedObject private var vm = MainMessagesViewModel()
    @State private var shouldShowMessageScreen = false
    @State var shouldNavigateToChatLogView = false
    
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil)
    
    var body: some View {
        VStack{
            
            customNavBar
            messagesView
            
            NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                ChatLogView(chatUser: self.chatUser)
            }

            
        }
        .overlay(Button{
            shouldShowMessageScreen.toggle()
        } label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
            .fullScreenCover(isPresented: $shouldShowMessageScreen, content: {
                CreateNewMessageView(didSelectNewUser: {user in
                    print(user.email)
                    self.shouldNavigateToChatLogView.toggle()
                    self.chatUser = user
                })
            }), alignment: .bottom)
    }
    
    @State var chatUser: ChatUser?
    
    private var customNavBar: some View {
        HStack(spacing: 16){
            VStack(alignment: .leading, spacing: 4){
                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                Text(email)
                    .font(.system(size: 24, weight: .bold))
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width:14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
            }
            Spacer()
            Button{
                
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
    }
    
    private var messagesView: some View {
        ScrollView{
            
            ForEach(vm.recentMessages){ msg in
                VStack{
                    Button{
                        
                        let uid = FirebaseManager.shared.auth.currentUser?.uid == msg.fromId ? msg.toId : msg.fromId
                        
                        self.chatUser = .init(id: uid, uid: uid, email: msg.email)
                        
                        self.chatLogViewModel.chatUser = self.chatUser
                        self.chatLogViewModel.fetchMessages()
                        self.shouldNavigateToChatLogView.toggle()
                        
//                        print(msg.email)
//                        self.shouldNavigateToChatLogView.toggle()
//
//                        let data = FirebaseManager.shared.firestore
//                            .collection("users")
//                            .whereField("email", isEqualTo: msg.email)
//
//                        self.chatUser = ChatUser(data: data)
                            
                    }label:{
                        HStack(spacing: 16){
                            VStack(alignment: .leading, spacing: 8){
                                Text(msg.username)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(.label))
                                Text(msg.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.darkGray))
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            Text(msg.timeAgo)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(.label))
                        }
                        Spacer()

                    }
                    
                    Divider()
                        .padding(.vertical, 8)
                }
                .padding(.horizontal)
            }
            
        }
        .padding(.bottom, 50)
    }
}


struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}

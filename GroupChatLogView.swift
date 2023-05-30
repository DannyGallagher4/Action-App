//
//  GroupChatLogView.swift
//  Action-App
//
//  Created by Danny Gallagher on 5/18/23.
//

import SwiftUI
import Firebase

struct GroupChatMessage: Identifiable{
    var id: String { documentId }
    
    let documentId: String
    
    let fromId, text, username: String
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
        self.username = data["username"] as? String ?? ""
    }
}

class GroupChatLogViewModel: ObservableObject{
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [GroupChatMessage]()


    init(){
        fetchMessages()
    }
    
    
    func handleSend(){
        print(chatText)
            
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        
        FirebaseManager.shared.firestore.collection("users").document(fromId).getDocument { document, error in
            if let error = error {
                print(error)
                let email = ""
                self.processEmail(email: email)
            } else {
                if let document = document, document.exists {
                    let data = document.data()
                    let email = data?["email"] as? String ?? ""
                    self.processEmail(email: email)
                }
            }
        }
        
    }
    
    func processEmail(email: String) {
    
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let username = email.components(separatedBy: "@").first ?? email
        
        let document = FirebaseManager.shared.firestore.collection("group-messages").document()
        
        let messageData = ["username": username, FirebaseConstants.fromId: fromId, FirebaseConstants.text: self.chatText, "timestamp": Timestamp()] as [String: Any]
        
        document.setData(messageData) { error in
            if let error = error {
                self.errorMessage = "Failed to save message: \(error)"
                return
            }
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
    }
    
    private func persistRecentMessage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}

        let doc = FirebaseManager.shared.firestore
            .collection("group_recent_messages")
            .document()
        
        print(doc)

        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
        ] as [String : Any]

        doc.setData(data){ error in
            if let error = error{
                self.errorMessage = "Failed to save to recents: \(error)"
                return
            }
        }
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages(){

        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("group-messages")
            .order(by: "timestamp")
            .addSnapshotListener{ querySnapshot, error in
                if let error = error{
                    self.errorMessage = "error fetching messages: \(error)"
                    print("error fetching messages: \(error)")
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added{
                        let data = change.document.data()
                        self.chatMessages.append(.init(documentId: change.document.documentID, data: data))
                    }

                })
                DispatchQueue.main.async {
                    self.count += 1
                }


            }
    }
    
    @Published var count = 0
}

struct GroupChatLogView: View {
    
    init(){
        self.vm = .init()
    }
    
    @ObservedObject var vm: GroupChatLogViewModel
    
    var body: some View {
        
        ZStack{
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle("Whole Team")
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarItems(trailing: Button(action: {
//            vm.count += 1
//        }, label: {
//            Text("Count: \(vm.count)")
//        }))
            
            
    }
    
    private var customBottomBar: some View{
        HStack(spacing: 16){
//            Image(systemName: "photo.on.rectangle")
//                .font(.system(size: 24))
//                .foregroundColor(Color(.darkGray))
            //TextEditor(text: $chatText)
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            Button{
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.ninjaBlue)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    static let emptyScrollToStr = "Empty"
    
    private var messagesView: some View{
        ScrollView{
            ScrollViewReader{scrollViewProxy in
                VStack{
                    ForEach(vm.chatMessages){message in
                        GroupMessageView(message: message)
                    }
                    
                    HStack{ Spacer() }
                        .id(Self.emptyScrollToStr)
                }
                .onReceive(vm.$count) { _ in
                    withAnimation(.easeOut(duration: 0.5)){
                        scrollViewProxy.scrollTo(Self.emptyScrollToStr, anchor: .bottom)
                    }
                    
                }
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom){
            customBottomBar
                .background(Color(.systemBackground).ignoresSafeArea())
        }
    }
}

struct GroupMessageView: View {
    
    let message: GroupChatMessage
    
    var body: some View {
        VStack{
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid{
                HStack{
                    Spacer()
                    HStack{
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.ninjaBlue)
                    .cornerRadius(8)
                }
            } else {
                VStack{
                    HStack{
                        
                        HStack{
                            Text(message.text)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        Spacer()
                    }
                    HStack{
                        Text(message.username)
                            .font(.system(size: 10))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct GroupChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        GroupChatLogView()
    }
}

//
//  ChatLogView.swift
//  Action-App
//
//  Created by Danny Gallagher on 4/20/23.
//

import SwiftUI
import Firebase

struct FirebaseConstants{
    static let fromId = "fromId"
    static let toId = "toId"
    static let text = "text"
    static let timestamp = "timestamp"
    static let email = "email"
}

struct ChatMessage: Identifiable{
    var id: String { documentId }
    
    let documentId: String
    
    let fromId, toId, text: String
    
    init(documentId: String, data: [String: Any]){
        self.documentId = documentId
        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
        self.toId = data[FirebaseConstants.toId] as? String ?? ""
        self.text = data[FirebaseConstants.text] as? String ?? ""
    }
}

class ChatLogViewModel: ObservableObject{
    @Published var chatText = ""
    @Published var errorMessage = ""
    @Published var chatMessages = [ChatMessage]()
    
    var chatUser: ChatUser?
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    
    func handleSend(){
        print(chatText)
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        
        let document =
            FirebaseManager.shared.firestore
                .collection("messages")
                .document(fromId)
                .collection(toId)
                .document()
        
        let messageData = [FirebaseConstants.fromId: fromId, FirebaseConstants.toId: toId, FirebaseConstants.text: self.chatText, "timestamp": Timestamp()] as [String: Any]
        
        document.setData(messageData){ error in
            if let error = error{
                self.errorMessage = "Failed to save message: \(error)"
                return
            }
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument =
            FirebaseManager.shared.firestore
                .collection("messages")
                .document(toId)
                .collection(fromId)
                .document()
        
        recipientMessageDocument.setData(messageData){ error in
            if let error = error{
                self.errorMessage = "Failed to save message: \(error)"
                return
            }
        }
    }
    
    private func persistRecentMessage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        guard let toId = self.chatUser?.uid else {return}
        guard let chatUser = chatUser else {return}
        
        let doc = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.email: chatUser.email
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
        
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        guard let toId = chatUser?.uid else {return}
        
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
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

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?){
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    @ObservedObject var vm: ChatLogViewModel
    
    var body: some View {
        
        ZStack{
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(chatUser?.email ?? "")
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
                        MessageView(message: message)
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

struct MessageView: View {
    
    let message: ChatMessage
    
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
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Message")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInforView()
    }
}

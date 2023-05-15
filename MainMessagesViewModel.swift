//
//  MainMessagesViewModel.swift
//  Action-App
//
//  Created by Danny Gallagher on 4/13/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecentMessage: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    let text, fromId, toId, email: String
    let timestamp: Date
    
    var username: String{
        email.components(separatedBy: "@").first ?? email
    }
    
    var timeAgo: String{
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
}

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email: String
}

class MainMessagesViewModel: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    
    init(){
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    @Published var recentMessages = [RecentMessage]()
    
    private var firestoreListener: ListenerRegistration?
    
    private func fetchRecentMessages(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnap, error in
                if let error = error{
                    self.errorMessage = "Failed to get recent message: \(error)"
                    return
                }
                
                querySnap?.documentChanges.forEach({change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    if let rm = try? change.document.data(as: RecentMessage.self){
                        self.recentMessages.insert(rm, at: 0)
                    }
                    
                })
            }
    }
    
    private func fetchCurrentUser() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "could not find firebase uid"
            return
        }
        
        self.errorMessage = "\(uid)"
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument{ snapshot, error in
            if let error = error {
                self.errorMessage = "falied to fetch currentUser: \(error)"
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
            
            
        }
        
    }
    
}

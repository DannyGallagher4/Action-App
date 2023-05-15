//
//  CommunicationView.swift
//  Action-App
//
//  Created by Danny Gallagher on 4/7/23.
//

import SwiftUI

struct CommunicationView: View {
    var messageArray = ["There was Thrawn", "He was the heir to the empire", "And Sabine looks great", "no armor tho", "Ik, its weird but I'm excited for sure"]
    
    var body: some View {
        VStack{
            VStack{
                TitleRow()
                
                ScrollView{
                    ForEach(messageArray, id: \.self){ text in
                        MessageBubble(message: Message(id: "23627627", text: text, received: true, timestamp: Date()))
                    }
                }
                .padding(.top, 10)
                .background(.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            }
            .background(Color.ninjaBlue)
            
            MessageField()
        }
    }
}

struct CommunicationView_Previews: PreviewProvider {
    static var previews: some View {
        CommunicationView()
    }
}

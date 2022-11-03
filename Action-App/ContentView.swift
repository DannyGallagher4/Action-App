//
//  ContentView.swift
//  Action-App
//
//  Created by Danny Gallagher on 10/19/22.
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


struct ContentView: View {
    @State private var steapPress = false
    @State private var ageGroup = "Kids"
    @State private var kidsOrMKs = true
    @State private var animationAmount = 1.0
    
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
        ZStack {
            Color.blue.ignoresSafeArea()
            
            VStack(){
                Button(action:{
                    steapPress = true
                }){
                    HStack{
                        Text("What Is STEAP?").fontWeight(.bold)
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .scaleEffect(animationAmount)
                    .animation(
                        .easeInOut(duration: 1).repeatForever(autoreverses: true),
                        value: animationAmount
                    )
                }
                .onAppear {
                    animationAmount = 1.2
                }
                
                

                Spacer()
                
                
                Image("actio-athletics-logo")
                Spacer()
                
                HStack{
                    Button(action:{
                        kidsOrMKs = true
                        ageGroup = "Kids"
                    }){
                        Text("Kids")
                            .modifier(ageModifier())
                    }
                    
                    Button(action:{
                        kidsOrMKs = true
                        ageGroup = "Mature Kids"
                    }){
                        Text("Mature Kids")
                            .modifier(ageModifier())
                    }
                    
                    Button(action:{
                        kidsOrMKs = false
                        ageGroup = "Pre-Teens"
                    }){
                        Text("Pre-Teens")
                            .modifier(ageModifier())
                    }
                    
                    Button(action:{
                        kidsOrMKs = false
                        ageGroup = "Teens"
                    }){
                        Text("Teens")
                            .modifier(ageModifier())
                    }
                    
                    Button(action:{
                        kidsOrMKs = false
                        ageGroup = "Young Adults"
                    }){
                        Text("Young Adults")
                            .modifier(ageModifier())
                    }
                }
                
                Text("\(ageGroup) Practice Times")
                    .fontWeight(.bold)
                    .font(.title2)
                    .padding()
                
                
                kidsOrMKs ? AnyView(practiceTimesKidsOrMKS) : AnyView(practiceTimesPreTeensAndUp)
                

            }.padding(20)
        }.alert("Strength, Technique, Experience, Accountability, Positivity", isPresented: $steapPress){
            Button("Return"){}
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

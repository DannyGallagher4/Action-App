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
    @State private var ageGroup = "Kids"
    @State private var kidsOrMKs = true
    @State private var podiumFinishes = UserDefaults.standard.integer(forKey: "podiumFinishes")
    
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
            VStack{
                NavigationLink{
                    
                    SteapView()
                    
                } label: {
                    HStack{
                        Text("What Is STEAP?").fontWeight(.bold)
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(LinearGradient(gradient: Gradient(colors: [.white, .yellow]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                }
                
                Image("actio-athletics-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .padding(40)
                
                VStack{
                    Text("Podium Finishes")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack{
                        Spacer()
                        Button{
                            podiumFinishes -= 1
                            UserDefaults.standard.set(podiumFinishes, forKey: "podiumFinishes")
                        } label: {
                            Text("-")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.largeTitle)
                        }
                        .buttonStyle(.bordered)
                        .tint(.yellow)
                        Text("\(podiumFinishes)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(10)
                        Button{
                            podiumFinishes += 1
                            UserDefaults.standard.set(podiumFinishes, forKey: "podiumFinishes")
                        } label: {
                            Text("+")
                                .foregroundColor(.black)
                                .fontWeight(.bold)
                                .font(.largeTitle)
                        }
                        .buttonStyle(.bordered)
                        .tint(.yellow)
                        Spacer()
                    }
                }
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
                
                
            }
            .padding(20)
            .background(.blue)
            .navigationTitle("Action Athletics")
        }
        .accentColor(.black)
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

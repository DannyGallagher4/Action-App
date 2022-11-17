//
//  SteapView.swift
//  Action-App
//
//  Created by Danny Gallagher on 11/16/22.
//

import SwiftUI

struct SteapView: View {
    var body: some View {
        ZStack{
            Color.blue
            
            VStack(alignment: .leading){
                VStack{
                    Text("S is for Strength")
                        .font(.title2.bold())
                        .padding(5)
                    
                    Text("It all starts with strength, if you do not have the physical ability to do some, ninja will be a great challenge.")
                        .padding(5)
                }
                
                
                VStack{
                    Text("T is for Technique")
                        .font(.title2.bold())
                        .padding(5)
                    
                    Text("Next up is technique. You can take the strongest person, but they will be unable to do well on obstacles if they have no technique.")
                        .padding(5)
                }
                
                VStack{
                    Text("E is for Experience")
                        .font(.title2.bold())
                        .padding(5)
                    
                    Text("Experience comes next. The more obstacles you try, the more ideas you will have when tackling new obstacles and the more comfortable you will feel on obstacles and courses.")
                        .padding(5)
                }
                
                VStack{
                    Text("A is for Accountability")
                        .font(.title2.bold())
                        .padding(5)
                    
                    Text("Accountability is very important to continually improving. The only way to get better is to practice, and the more accountable you are during practice time, the more improvements will be made.")
                        .padding(5)
                }
                
                VStack{
                    Text("P is for Positivity")
                        .font(.title2.bold())
                        .padding(5)
                    
                    Text("And finally, positivity. Positivity helps in all facets of ninja, positive energy will improve your performance as well as the runs of teammates.")
                        .padding(5)
                }
            
            }
            .padding(.top, 60)
            .padding([.horizontal, .bottom], 10)
        }
        .ignoresSafeArea()
        
    }
}

struct SteapView_Previews: PreviewProvider {
    static var previews: some View {
        SteapView()
    }
}

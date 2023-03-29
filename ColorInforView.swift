//
//  ColorInforView.swift
//  Action-App
//
//  Created by Danny Gallagher on 3/1/23.
//

import SwiftUI

struct ColorInforView: View {
    var body: some View {
        VStack{
            HStack{
                Circle()
                    .foregroundColor(Color.ninjaYellow)
                    .frame(width: 30, height: 30)
                    .padding(.trailing)
                
                Text("Practice")
                    .font(.title)
            }
            HStack{
                Circle()
                    .foregroundColor(Color.pink)
                    .frame(width: 30, height: 30)
                    .padding(.trailing)
                
                Text("Competition")
                    .font(.title)
            }
            HStack{
                Circle()
                    .foregroundColor(Color.orange)
                    .frame(width: 30, height: 30)
                    .padding(.trailing)
                
                Text("Other")
                    .font(.title)
            }
            
            Text("Press the ? to Return")
                .font(.title2)
        }
        .padding()
        .background(Color.ninjaBlue)
        .border(Color.black, width: 4)
    }
}

struct ColorInforView_Previews: PreviewProvider {
    static var previews: some View {
        ColorInforView()
    }
}

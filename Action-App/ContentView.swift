//
//  ContentView.swift
//  Action-App
//
//  Created by Danny Gallagher on 10/19/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.blue
                
            Image("actio-athletics-logo")
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

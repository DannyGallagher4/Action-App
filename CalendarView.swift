//
//  CalendarView.swift
//  Action-App
//
//  Created by Danny Gallagher on 2/2/23.
//

import SwiftUI

struct ConditionalModifier: ViewModifier {
    var condition: Bool
    @Binding var isShowingAddEvent: Bool
    
    func body(content: Content) -> some View {
        if condition {
            content
                .safeAreaInset(edge: .bottom, content: {
                    HStack{
                        Button{
                            isShowingAddEvent = true
                        } label: {
                            Text("Add Event")
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(Color.ninjaYellow, in: Capsule())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .background(.ultraThinMaterial)
                })
        } else {
            content
        }
    }
}

struct CalendarView: View {
    
    @State var currentDate: Date = Date()
    @State var isShowingAddEvent = false
    @State var isCoach = true
    @State var isShowingInfo = false
    @State var blurAmt = 0.0
    
    var body: some View{
        
        ZStack{
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 20){
                    CustomDatePickerView(currentDate: $currentDate)
                }
          //      .padding(.vertical)
                .toolbar{
                    Button{
                        isShowingInfo.toggle()
                        if isShowingInfo{
                            blurAmt = 20.0
                        } else {
                            blurAmt = 0.0
                        }
                    } label: {
                        Image(systemName: "questionmark")
                            .foregroundColor(.black)
                    }
                }
            }
            .blur(radius: blurAmt)
            .modifier(ConditionalModifier(condition: isCoach, isShowingAddEvent: $isShowingAddEvent))
            .sheet(isPresented: $isShowingAddEvent){
                AddEventView()
            }
            .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            
            if isShowingInfo{
                ColorInforView()
            }
            
        }
    }
        
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

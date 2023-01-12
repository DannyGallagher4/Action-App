//
//  ContentView.swift
//  Action-App
//
//  Created by Danny Gallagher on 10/19/22.
//

import SwiftUI


struct CShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

struct CShapeSignUp: Shape {
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}


struct ContentView: View {
    
    var body: some View {
        Home()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View{
    @State var index = 0
    @State var showingPassword = false
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                Spacer()
                
                Image("action-athletics-logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                ZStack{
                    SignUp(index: $index, showingPassword: $showingPassword)
                        .zIndex(Double(index))
                    
                    Login(index: $index, showingPassword: $showingPassword)
                }
                
                HStack(spacing: 15){
                    
                    Rectangle()
                        .fill(.white)
                        .frame(height: 1)
                    
                    Text("OR")
                        .foregroundColor(.white)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(height: 1)

                }
                .padding(.horizontal, 30)
                .padding(.top, 50)
                
                HStack(spacing: 25){
                    
                    Button{
                        
                        
                        
                    } label: {
                        
                        Image("google")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                    }
                    
                    Button{
                        
                        
                        
                    } label: {
                        
                        Image("apple")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                    }
                    
                    Button{
                        
                        
                        
                    } label: {
                        
                        Image("fb")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                    }
                    
                }
                .padding(.top, 30)
                
                Spacer()
                
            }
            .padding(.vertical)
        }
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
        
    }
    
}

struct Login: View{
    
    @State var email = ""
    @State var pass = ""
    @Binding var index: Int
    @Binding var showingPassword: Bool
    
    var body: some View{
        ZStack(alignment: .bottom){
            
            VStack{
                
                HStack{
                    
                    VStack(spacing: 10){
                        Text("Login")
                            .foregroundColor(index == 0 ? .black : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(index == 0 ? .black : .clear)
                            .frame(width: 100, height: 5)
                    }
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.top, 30)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.ninjaBlue)
                        
                        TextField("Email Address", text: $email)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack{
                    HStack(spacing: 15){
                        Button{
                            showingPassword.toggle()
                        } label: {
                            Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.ninjaBlue)
                        }
                        
                        if showingPassword {
                            TextField("Password", text: $pass)
                        }
                        else {
                            SecureField("Password", text: $pass)
                        }
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        Text("Forget Password?")
                            .foregroundColor(Color.blue.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(LinearGradient(gradient: Gradient(colors: [.white, .ninjaYellow]), startPoint: .leading, endPoint: .trailing))
            .clipShape(CShape())
            .contentShape(CShape())
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture(){
                index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            Button(){
                
            } label: {
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(.black)
                    .clipShape(Capsule())
                    .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(index == 0 ? 1 : 0)
            
        }
    }
    
}

struct SignUp: View{
    
    @State var email = ""
    @State var pass = ""
    @State var Repass = ""
    @Binding var index: Int
    
    @Binding var showingPassword: Bool
    
    var body: some View{
        ZStack(alignment: .bottom){
            
            VStack{
                
                HStack{
                    
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 10){
                        
                        Text("SignUp")
                            .foregroundColor(index == 1 ? .black : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(index == 1 ? .black : .clear)
                            .frame(width: 100, height: 5)
                        
                    }
                    
                }
                .padding(.top, 30)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.ninjaBlue)
                        
                        TextField("Email Address", text: $email)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack{
                    HStack(spacing: 15){
                        Button{
                            showingPassword.toggle()
                        } label: {
                            Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.ninjaBlue)
                        }
                        
                        if showingPassword {
                            TextField("Password", text: $pass)
                        }
                        else {
                            SecureField("Password", text: $pass)
                        }
                            
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                VStack{
                    HStack(spacing: 15){
                        Button{
                            showingPassword.toggle()
                        } label: {
                            Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.ninjaBlue)
                        }
                        
                        if showingPassword {
                            TextField("Re-Enter Password", text: $Repass)
                        }
                        else {
                            SecureField("Re-Enter Password", text: $Repass)
                        }
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
            }
            .padding()
            .padding(.bottom, 65)
            .background(LinearGradient(gradient: Gradient(colors: [.white, .ninjaYellow]), startPoint: .leading, endPoint: .trailing))
            .clipShape(CShapeSignUp())
            .contentShape(CShapeSignUp())
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture(){
                index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal, 20)
            
            Button(){
                
            } label: {
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(.black)
                    .clipShape(Capsule())
                    .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(index == 1 ? 1 : 0)
            
        }
    }
    
}

extension Color {
    static let ninjaYellow = Color("NinjaYellow")
    static let ninjaBlue = Color("NinjaBlue")
}

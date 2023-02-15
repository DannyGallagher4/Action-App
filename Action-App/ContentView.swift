//
//  ContentView.swift
//  Action-App
//
//  Created by Danny Gallagher on 10/19/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


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
    
    @State var showingMainView = false
    @State var showingLoginAndSignUpView = false
    @State var showingCalendarView = true
    
    @StateObject var currentUser = CurrentUser(myId: "", myEmail: "")
    
    var body: some View {
        if showingLoginAndSignUpView{
            LoginAndSignUpView(showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView, currentUser: currentUser)
        } else if showingMainView{
            MainView(showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView, currentUser: currentUser)
        } else if showingCalendarView{
            CalendarView()
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoginAndSignUpView: View{
    @State var index = 0
    @State var showingPassword = false
    @State var coachSignUp = false
    
    @State var coaches = UserDefaults.standard.object(forKey: "coaches") as? [String] ?? [String]()
    
    @Binding var showingMainView: Bool
    @Binding var showingLoginAndSignUpView: Bool
    @ObservedObject var currentUser: CurrentUser
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                Image("action-athletics-logo")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .padding(.top, 40)
                
                ZStack{
                    SignUpView(index: $index, showingPassword: $showingPassword, coachSignUp: $coachSignUp, showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView)
                        .zIndex(Double(index))
                    
                    LoginView(index: $index, showingPassword: $showingPassword, showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView, currentUser: currentUser)
                }
                .padding(.top, 20)
            }
            .padding(.vertical)
        }
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
        
    }
    
}

struct LoginView: View{
    
    @State var email = ""
    @State var pass = ""
    @State private var showingPassReset = false
    @State private var emailForPassReset = ""
    @State private var showingEmailSent = false
    
    @Binding var index: Int
    @Binding var showingPassword: Bool
    @Binding var showingMainView: Bool
    @Binding var showingLoginAndSignUpView: Bool
    
    @ObservedObject var currentUser: CurrentUser
    
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
                .padding(.top, 40)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.ninjaBlue)
                        
                        TextField("Email Address", text: $email)
                            .textCase(.lowercase)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                    
                    
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
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
                .padding(.top, 40)
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        showingPassReset = true
                    }){
                        Text("Forget Password?")
                            .foregroundColor(Color.blue.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 40)
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
                
                Auth.auth().signIn(withEmail: email, password: pass) { authResult, error in
                    if let _eror = error{
                        print(_eror.localizedDescription)
                    }else{
                        
                        if let _res = authResult{
                            print(_res.user.email ?? "no email")
                            
                            currentUser.id = authResult?.user.uid ?? ""
                            currentUser.email = authResult?.user.email ?? ""
                            
                            showingMainView = true
                            showingLoginAndSignUpView = false
                            
                        } else{
                            print("error with authResult")
                        }

                    }
                    
                    print(currentUser.id + " " + currentUser.email)
                    
                    print("loginview \(showingMainView)")
            
                }

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
        .alert("What email Would You Like To Use To Reset Your Password?", isPresented: $showingPassReset) {
            
            TextField("Email", text: $emailForPassReset)
            HStack{
                
                Button("Send Password Reset"){
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        
                    }
                }
                
                Button("Cancel"){
                    showingPassReset = false
                }
            }
            
        }
    }
    
}

struct SignUpView: View{
    
    @State var email = ""
    @State var pass = ""
    @State var Repass = ""
    @State var coachKey = ""
    
    @Binding var index: Int
    
    @Binding var showingPassword: Bool
    
    @Binding var coachSignUp: Bool
    
    @Binding var showingMainView: Bool
    
    @Binding var showingLoginAndSignUpView: Bool
    
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
                            .textCase(.lowercase)
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
                
                VStack{
                    HStack(spacing: 15){
                        Toggle("Sign Up As A Coach", isOn: $coachSignUp)
                    }
                    
                    if coachSignUp {
                        
                        HStack(spacing: 15){
                            
                            Button{
                                showingPassword.toggle()
                            } label: {
                                Image(systemName: showingPassword ? "eye.fill" : "eye.slash.fill")
                                    .foregroundColor(.ninjaBlue)
                            }
                            
                            if showingPassword {
                                TextField("Coach's Key", text: $coachKey)
                            }
                            else {
                                SecureField("Coach's Key", text: $coachKey)
                            }
                            
                        }
                        .padding(.top, 5)
                        
                        Divider().background(Color.white.opacity(0.5))
                        
                    }
                }
                .padding()
                
            }
            .padding()
            .padding(.bottom, coachSignUp ? 10: 47)
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
                
                if pass == Repass{
                    
                    Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                        if let _eror = error{
                            print(_eror.localizedDescription)
                        }else{
                            if let _res = authResult{
                                print(_res.user.email ?? "no email")
                                
                                if(coachSignUp){
                                    if coachKey == "AA"{
                                        var basicArr = UserDefaults.standard.object(forKey: "coaches") as? [String] ?? [String]()
                                        print(basicArr)
                                        basicArr.append(email)
                                        
                                        UserDefaults.standard.set(basicArr, forKey: "coaches")
                                    }
                                }
                                
                                showingMainView = true
                                showingLoginAndSignUpView = false
                            }
            
                        }
                        
                    }
                    
                    print(UserDefaults.standard.array(forKey: "coaches") ?? "none")
                    
                } else {
                    print("passwords do not match")
                }
                
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

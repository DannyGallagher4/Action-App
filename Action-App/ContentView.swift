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
    @State private var isLoading = true
    
    @StateObject var currentUser = CurrentUser(myId: "", myEmail: "")
    
    var body: some View {
        
        VStack{
            
            if isLoading{
                ZStack{
                    Color.ninjaBlue
                        .edgesIgnoringSafeArea(.all)
                    
                    Image("action-athletics-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(10)
                }
            } else if showingLoginAndSignUpView{
                LoginAndSignUpView(showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView, currentUser: currentUser)
            } else if showingMainView{
                withAnimation{
                    MainView(showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView, currentUser: currentUser)
                }
            }
        }
        .onAppear(){
            checkAuthentication()
        }
    }
    
    func checkAuthentication() {
        // Check if a user is signed in
        let loadingTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                // Stop loading after a minimum of 2 seconds
                
                // Check if a user is signed in
            if let currentUser = FirebaseManager.shared.auth.currentUser {
                showingLoginAndSignUpView = false
                showingMainView = true
            } else {
                // User is not signed in
                showingLoginAndSignUpView = true
                showingMainView = false
            }
                
            // Stop loading
            isLoading = false
        }
            
        // Perform the authentication check asynchronously
        DispatchQueue.global().async {
            // Simulate authentication check delay
            Thread.sleep(forTimeInterval: 5)
            
            // Invalidate the timer if the check completes before the minimum 2 seconds
            loadingTimer.invalidate()
            
            DispatchQueue.main.async {
                // Stop loading if the minimum 2 seconds have passed
                isLoading = false
            }
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
    
    @Binding var showingMainView: Bool
    @Binding var showingLoginAndSignUpView: Bool
    @ObservedObject var currentUser: CurrentUser
    
    var body: some View{
        VStack{
                
            Image("action-athletics-logo")
                .resizable()
                .frame(width: 140, height: 140)
                .padding(.top, 20)
            
            ZStack{
                SignUpView(index: $index, showingPassword: $showingPassword, coachSignUp: $coachSignUp, showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView)
                    .zIndex(Double(index))
                
                LoginView(index: $index, showingPassword: $showingPassword, showingMainView: $showingMainView, showingLoginAndSignUpView: $showingLoginAndSignUpView, currentUser: currentUser)
            }
            .padding(.top, 20)
            .padding(.bottom, 45)
        }
        .padding(.vertical)
        .background(Color.ninjaBlue.edgesIgnoringSafeArea(.all))
        
    }
    
}

struct LoginView: View{
    
    @State var email = ""
    @State var pass = ""
    @State private var showingPassReset = false
    @State private var emailForPassReset = ""
    @State private var showingEmailSent = false
    
    @FocusState var isInputActive: Bool
    @FocusState var isInputActive2: Bool
    @FocusState var isInputActive3: Bool
    
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
                            .keyboardType(.default)
                            .focused($isInputActive)
                            
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
                                .keyboardType(.default)
                                .focused($isInputActive2)
                                
                        }
                        else {
                            SecureField("Password", text: $pass)
                                .keyboardType(.default)
                                .focused($isInputActive3)
                                
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
                
                FirebaseManager.shared.auth.signIn(withEmail: email, password: pass) { authResult, error in
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if index == 0{
                    Spacer()
                    
                    Button("Done") {
                        
                        isInputActive = false
                        isInputActive2 = false
                        isInputActive3 = false
                        
                    }
                }
            }
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
    
    @FocusState var isInputActive: Bool
    @FocusState var isInputActive2: Bool
    @FocusState var isInputActive3: Bool
    @FocusState var isInputActive4: Bool
    @FocusState var isInputActive5: Bool
    @FocusState var isInputActive6: Bool
    @FocusState var isInputActive7: Bool
    
    @State var showAlert = false
    
    @State var alertMsg = ""
    
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
                            .keyboardType(.default)
                            .focused($isInputActive)
                            
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
                                .keyboardType(.default)
                                .focused($isInputActive2)
                                
                        }
                        else {
                            SecureField("Password", text: $pass)
                                .keyboardType(.default)
                                .focused($isInputActive3)
                                
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
                                .keyboardType(.default)
                                .focused($isInputActive4)
                                
                        }
                        else {
                            SecureField("Re-Enter Password", text: $Repass)
                                .keyboardType(.default)
                                .focused($isInputActive5)
                                
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
                                    .keyboardType(.default)
                                    .focused($isInputActive6)
                            }
                            else {
                                SecureField("Coach's Key", text: $coachKey)
                                    .keyboardType(.default)
                                    .focused($isInputActive7)
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
                
                storeUserInformation()
                
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                if index == 1{
                    Spacer()
                    
                    Button("Done") {
                        isInputActive = false
                        isInputActive2 = false
                        isInputActive3 = false
                        isInputActive4 = false
                        isInputActive5 = false
                        isInputActive6 = false
                        isInputActive7 = false
                    }
                }
            }
        }
        .alert(alertMsg, isPresented: $showAlert) {
            Button("Close", role: .cancel){ }
        }
    }
    
    private func storeUserInformation(){
        if pass == Repass{
            if coachSignUp{
                if coachKey == "AA"{
                    FirebaseManager.shared.auth.createUser(withEmail: email, password: pass) { authResult, error in
                        if let _eror = error{
                            print(_eror.localizedDescription)
                        }else{
                            if let _res = authResult{
                                print(_res.user.email ?? "no email")
                                
                                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                                
                                let userData = ["email": email, "uid": uid, "isCoach": true] as [String : Any]
                                FirebaseManager.shared.firestore.collection("users")
                                        .document(uid).setData(userData) { err in
                                            if let err = err {
                                                print(err)
                                                return
                                            }
                                        }
                                
                                showingMainView = true
                                showingLoginAndSignUpView = false
                            }
                            
                        }
                    }
                } else {
                    alertMsg = "Wrong Coach Key"
                    showAlert = true
                }
            } else {
                FirebaseManager.shared.auth.createUser(withEmail: email, password: pass) { authResult, error in
                    if let _eror = error{
                        print(_eror.localizedDescription)
                    }else{
                        if let _res = authResult{
                            print(_res.user.email ?? "no email")
                            
                            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                            
                            let userData = ["email": email, "uid": uid, "isCoach": false] as [String : Any]
                            FirebaseManager.shared.firestore.collection("users")
                                .document(uid).setData(userData) { err in
                                    if let err = err {
                                        print(err)
                                        return
                                    }
                                }
                            
                            showingMainView = true
                            showingLoginAndSignUpView = false
                                
                        }
        
                    }
                    
                }
            }
        } else {
            alertMsg = "Passwords do not match"
            showAlert = true
        }
    }
    
}

extension Color {
    static let ninjaYellow = Color("NinjaYellow")
    static let ninjaBlue = Color("NinjaBlue")
}

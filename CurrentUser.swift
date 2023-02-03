//
//  CurrentUser.swift
//  Action-App
//
//  Created by Danny Gallagher on 1/26/23.
//

import SwiftUI

class CurrentUser: ObservableObject{
    var id: String
    var email: String
    
    init(myId: String, myEmail: String){
        id = myId
        email = myEmail
    }
}

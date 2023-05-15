//
//  TitleRow.swift
//  Action-App
//
//  Created by Danny Gallagher on 4/7/23.
//

import SwiftUI

struct TitleRow: View {
    var name = "Danny Gallagher"
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading){
                Text(name)
                    .font(.title).bold()
                
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
//            Image(systemName: "phone.fill")
//                .foregroundColor(.gray)
//                .padding(10)
//                .background(.white)
//                .cornerRadius(50)
        }
        .padding()
    }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
    }
}

//
//  ContentView.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/29/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var loginModel = AuthViewModel()
    @StateObject var viewModel = CalendarViewModel()

    var body: some View {
        Group {
            if loginModel.userSession != nil {
                CalendarTabView()
                    .environmentObject(loginModel)
            } else {
                LoginView(viewModel: loginModel)
            }
        }
       
        
    }
}

#Preview {
    ContentView()
}



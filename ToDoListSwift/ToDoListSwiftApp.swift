//
//  ToDoListSwiftApp.swift
//  ToDoListSwift
//
//  Created by Hamza Wahab on 11/12/2024.
//

import SwiftUI
import Firebase
@main
struct ToDoListSwiftApp: App {
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ListView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listViewModel)
            .environmentObject(viewModel)
        }
    }
}

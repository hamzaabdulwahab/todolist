//
//  AuthViewModel.swift
//  ToDoListSwift
//
//  Created by Hamza Wahab on 29/12/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}
@MainActor
class AuthViewModel : ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    
    init () {
        self.userSession = Auth.auth().currentUser
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password:  String) async throws {
        isLoading = true
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            // Set alert properties
            alertTitle = "Sign-In Failed"
            alertMessage = error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }
    
    func createuser(withEmail email: String, password:  String, fullname: String) async throws {
        isLoading = true
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
        isLoading = false
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            alertTitle = "Sign-In Failed"
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in."])
        }

        let userId = user.uid
        
        // Step 1: Delete Firestore user data
        do {
            try await Firestore.firestore().collection("users").document(userId).delete()
            print("DEBUG: User Firestore data deleted.")
        } catch {
            print("ERROR: Failed to delete Firestore user data - \(error.localizedDescription)")
            throw NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete Firestore user data."])
        }
        
        // Step 2: Delete Firebase Auth user account
        do {
            try await user.delete()
            print("DEBUG: Firebase Auth account deleted.")
            
            // Step 3: Clear session and currentUser
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("ERROR: Failed to delete Firebase Auth account - \(error.localizedDescription)")
            throw NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to delete Firebase account. Please try signing out and logging back in to retry."])
        }
    }
    
    private func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is \(String(describing: self.currentUser))")
    }
}

//
//  LoginView.swift
//  ToDoListSwift
//
//  Created by Hamza Wahab on 28/12/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationView {
            VStack{
                Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width:120, height: 140)
                .foregroundStyle(Color.accentColor)
                .padding(.vertical, 32)
                .shadow(color: Color.accentColor.opacity(0.3),
                        radius: 5,
                        x: 5,
                        y: 5)
                .shadow(color: Color.accentColor.opacity(0.3),
                        radius: 5,
                        x: -5,
                        y: 0)
                
                // form  fields
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeHolder: "name@example.com")
                        .autocapitalization(.none)
                    InputView(text: $password,
                              title: "Password",
                              placeHolder: "Enter your password",
                              isSecureField: true
                    )
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("sign in".uppercased())
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.accentColor)
                .cornerRadius(10)
                .opacity(formIsValid ? 1.0 : 0.5)
                .disabled(!formIsValid)
                .padding(.top, 24)
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.alertTitle),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Spacer()
                
                // sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 2) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }

            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 6
    }
    
    
}
#Preview {
    NavigationView{
        LoginView()
    }
    .environmentObject(AuthViewModel())
}

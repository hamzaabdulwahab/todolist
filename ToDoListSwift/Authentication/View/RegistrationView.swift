//
//  RegistrationView.swift
//  ToDoListSwift
//
//  Created by Hamza Wahab on 29/12/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var fullname: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        VStack {
            Image("firebaselogo")
                .resizable()
                .scaledToFill()
                .frame(width:120, height: 140)
                .shadow(
                    color: Color(#colorLiteral(red: 0.8654338121, green: 0.1720753014, blue: 0, alpha: 1)).opacity(0.4),
                    radius: 5,
                        x: 5,
                    y: -5
                )
                .shadow(
                    color: Color(#colorLiteral(red: 1, green: 0.7671757936, blue: 0.01299781911, alpha: 1)).opacity(0.4),
                    radius: 5,
                        x: -5,
                    y: 5
                )
                .padding(.vertical, 32)
            VStack(spacing: 24) {
                InputView(text: $email,
                          title: "Email Address",
                          placeHolder: "name@example.com")
                    .autocapitalization(.none)
                InputView(text: $fullname,
                          title: "Full Name",
                          placeHolder: "Enter your name")
                InputView(text: $password,
                          title: "Password",
                          placeHolder: "Enter your password",
                          isSecureField: true)
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeHolder: "Confirm your password",
                              isSecureField: true)
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.medium)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.medium)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.systemRed))
                        }
                    }
                }
                
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            Button {
                Task {
                    try await viewModel.createuser(withEmail: email, password: password, fullname: fullname)
                }
            } label: {
                HStack{
                    Text("sign up".uppercased())
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color.accentColor)
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                dismiss()
            } label : {
                HStack(spacing: 2) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size: 14))
            }
        }
        
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !fullname.isEmpty
        && !password.isEmpty
        && password.count >= 6
        && password == confirmPassword
    }
}

#Preview {
    NavigationView{
        RegistrationView()
    }
        .environmentObject(AuthViewModel())
}

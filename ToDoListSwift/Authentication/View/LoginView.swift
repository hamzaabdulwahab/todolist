import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(AuthViewModel.self) var viewModel: AuthViewModel
    var body: some View {
        NavigationView {
            VStack{
                Image("firebaselogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width:120, height: 139)
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
                    InputView(text: $password,
                              title: "Password",
                              placeHolder: "Enter your password",
                              isSecureField: true
                    )
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
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


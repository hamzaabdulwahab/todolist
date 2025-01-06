import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var textFieldText: String = ""
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    private let db = Firestore.firestore()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                TextField("Type something here", text: $textFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                
                Button(action: saveButtonPressed, label: {
                    Text("Save".uppercased())
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
            }
            .padding(14)
        }
        .navigationTitle("Add an Item 🖍️")
        .alert(isPresented: $showAlert, content: getAlert)
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() {
            saveTaskToFirestore()
        }
    }
    
    func textIsAppropriate() -> Bool {
        if textFieldText.count < 3 {
            alertTitle = "Item must be at least 3 characters long ‼️"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        Alert(title: Text(alertTitle))
    }
    
    /// Save the task to Firestore inside the user's document
    private func saveTaskToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertTitle = "User is not signed in."
            showAlert.toggle()
            return
        }
        
        let newTask = [
            "id": UUID().uuidString,
            "title": textFieldText,
            "isCompleted": false,
            "createdAt": FieldValue.serverTimestamp()
        ] as [String: Any]
        
        db.collection("users") // Main users collection
            .document(userId) // Current user's document
            .collection("tasks") // Subcollection for tasks
            .addDocument(data: newTask) { error in
                if let error = error {
                    alertTitle = "Failed to save task: \(error.localizedDescription)"
                    showAlert.toggle()
                } else {
                    print("Task added successfully to user \(userId)'s tasks collection.")
                    presentationMode.wrappedValue.dismiss()
                }
            }
    }
}

#Preview {
    NavigationView {
        AddView()
    }
}

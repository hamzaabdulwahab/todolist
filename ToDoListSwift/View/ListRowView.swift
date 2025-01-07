import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ListRowView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    let item: ItemModel
    @State private var isCompleted: Bool
    
    private let db = Firestore.firestore()
    
    init(item: ItemModel) {
        self.item = item
        self._isCompleted = State(initialValue: item.isCompleted)
    }
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle" : "circle")
                .foregroundStyle(isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }
        .onTapGesture {
            toggleTaskCompletion()
            listViewModel.fetchTasks()
        }
        .font(.title3)
        .padding(.vertical, 3.5)
    }
    private func toggleTaskCompletion() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not signed in.")
            return
        }
        isCompleted.toggle()
        db.collection("users")
            .document(userId)
            .collection("tasks")
            .document(item.id)
            .updateData(["isCompleted": isCompleted]) { error in
                if let error = error {
                    print("Error updating task completion status: \(error.localizedDescription)")
                } else {
                    print("Task completion status updated successfully.")
                }
            }
        
    }
}

#Preview {
    ListRowView(item: ItemModel(title: "ham", isCompleted: true))
}

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ListRowView: View {
    let item: ItemModel
    @State private var isCompleted: Bool // Local state for the completion status

    private let db = Firestore.firestore()

    init(item: ItemModel) {
        self.item = item
        self._isCompleted = State(initialValue: item.isCompleted)
    }

    var body: some View {
        HStack {
            // Task Completion Toggle
            Image(systemName: isCompleted ? "checkmark.circle" : "circle")
                .foregroundStyle(isCompleted ? .green : .red)
                .onTapGesture {
                    toggleTaskCompletion()
                }

            // Task Title
            Text(item.title)
            Spacer()
        }
        .font(.title3)
        .padding(.vertical, 3.5)
    }

    /// Toggles the completion status of the task in Firestore.
    private func toggleTaskCompletion() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not signed in.")
            return
        }

        // Toggle local state
        isCompleted.toggle()

        // Update Firestore database
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

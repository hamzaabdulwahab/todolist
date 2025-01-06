import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var tasks: [ItemModel] = []
    @State private var loading = true
    @State private var showAddTaskView = false
    
    private let db = Firestore.firestore()
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                NavigationView {
                    VStack {
                        if loading {
                            ProgressView("Loading tasks...")
                        } else if tasks.isEmpty {
                            NoItemsView()
                                .transition(AnyTransition.opacity.animation(.easeIn))
                            
                        } else {
                            List {
                                ForEach(tasks) { task in
                                    ListRowView(item: task)
                                }
                                .onDelete(perform: deleteTask)
                            }
                        }
                    }
                    .onAppear {
                        fetchTasks()
                    }
                    .navigationTitle("My Tasks")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AddView()
                                .onDisappear {
                                    fetchTasks()
                                }) {
                                    Label("Add Task", systemImage: "plus")
                                        .padding(.bottom)
                                }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.primary)
                                    .font(.title2)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: authViewModel.userSession)
    }
    private func fetchTasks() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user signed in.")
            loading = false
            return
        }
        
        db.collection("users")
            .document(userId)
            .collection("tasks")
            .order(by: "createdAt", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching tasks: \(error.localizedDescription)")
                    loading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No tasks found.")
                    loading = false
                    return
                }
                
                self.tasks = documents.map { doc in
                    let data = doc.data()
                    let id = doc.documentID
                    let title = data["title"] as? String ?? "Untitled Task"
                    let isCompleted = data["isCompleted"] as? Bool ?? false
                    return ItemModel(id: id, title: title, isCompleted: isCompleted)
                }
                .sorted { !$0.isCompleted && $1.isCompleted }
                
                loading = false
            }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user signed in.")
            return
        }
        
        offsets.forEach { index in
            let taskToDelete = tasks[index]
            
            db.collection("users")
                .document(userId)
                .collection("tasks")
                .document(taskToDelete.id)
                .delete { error in
                    if let error = error {
                        print("Error deleting task: \(error.localizedDescription)")
                    } else {
                        print("Task deleted successfully.")
                        
                        DispatchQueue.main.async {
                            tasks.remove(at: index)
                        }
                    }
                }
        }
    }
}

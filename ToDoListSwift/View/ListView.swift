////
////  ListView.swift
////  ToDoListSwift
////
////  Created by Hamza Wahab on 11/12/2024.
////
//
//import SwiftUI
////import TodoListModule
//
//struct ListView: View {
//    @State var name: String = ""
//    @State private var isShowingProfile = false
//    @EnvironmentObject var listViewModel: ListViewModel
//    @EnvironmentObject var viewModel: AuthViewModel
//
//    var body: some View {
//        VStack {
//            Group {
//                if viewModel.isLoading {
//                                    ProgressView("Loading...")
//                                        .progressViewStyle(CircularProgressViewStyle())
//                                }
//                else if viewModel.currentUser != nil {
//                    ZStack {
//                        if listViewModel.items.isEmpty {
//                            NoItemsView()
//                                .transition(AnyTransition.opacity.animation(.easeIn))
//                        } else {
//                            List {
//                                ForEach(listViewModel.items) { item in
//                                    ListRowView(item: item)
//                                        .onTapGesture {
//                                            withAnimation(.linear) {
//                                                listViewModel.updateItem(item: item)
//                                            }
//                                        }
//                                }
//                                .onDelete(perform: listViewModel.deleteItem)
//                                .onMove(perform: listViewModel.moveItem)
//                            }
//                            .listStyle(PlainListStyle())
//                        }
//                    }
//                    .navigationTitle("Todo List 📝")
//                    .navigationBarItems(
//                        leading: EditButton(),
//                        trailing: NavigationLink("Add", destination: AddView())
//                    )
//
//                    Spacer()
//                    HStack {
//                        Spacer()
//
//                        // Profile Button - This is where the profile view is triggered
//                        Button {
//                            isShowingProfile = true
//                        } label: {
//                            Image(systemName: "gear")
//                                .font(.system(size: 28))
//                                .foregroundColor(Color(.systemGray))
//                                .padding()
//                        }
//                    }
//                } else {
//                    LoginView()
//                        .environmentObject(viewModel)
//
//
//                }
//            }
//        }
//        .fullScreenCover(isPresented: $isShowingProfile) {
//            ProfileView()
//                .environmentObject(viewModel)
//        }
//    }
//}
//
//#Preview {
//    NavigationView{
//        ListView()
//    }
//    .environmentObject(ListViewModel())
//    .environmentObject(AuthViewModel())\



import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // Access AuthViewModel
    @State private var tasks: [ItemModel] = []
    @State private var loading = true
    @State private var showAddTaskView = false // State to toggle AddView
    
    private let db = Firestore.firestore()
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                // User is authenticated, show the list view
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
                                .onDelete(perform: deleteTask) // Enable swipe-to-delete
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
                                    fetchTasks() // Refresh tasks after adding
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
                // User is not authenticated, show sign-in view
                LoginView()
            }
        }
        .padding(.top, 50)
        .animation(.easeInOut, value: authViewModel.userSession) // Smooth transition
    }
    
    /// Fetch tasks from Firestore for the currently signed-in user.
    private func fetchTasks() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user signed in.")
            loading = false
            return
        }

        db.collection("users")
            .document(userId)
            .collection("tasks")
            .order(by: "createdAt", descending: false) // Order by creation time
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
                .sorted { !$0.isCompleted && $1.isCompleted } // Ensure false appears before true

                loading = false
            }
    }
    
    /// Delete task from Firestore
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
                        
                        // Update local tasks array on the main thread
                        DispatchQueue.main.async {
                            tasks.remove(at: index)
                        }
                    }
                }
        }
    }
}

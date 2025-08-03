
import Foundation
import TodoListModule
import FirebaseFirestore
import FirebaseAuth

@Observable class ListViewModel {
    private let db = Firestore.firestore()
    var items: [ItemModel] = []
    var searchText: String = ""
    var loading = true
    let itemsKey: String = "items_list"
    var todoList: TodoList
    init() {
        self.todoList = TodoList()
        // getItems()
    }
    public func deleteTask(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user signed in.")
            return
        }
        
        offsets.forEach { index in
            let taskToDelete = items[index]
            
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
                            self.items.remove(at: index)
                        }
                    }
                }
        }
    }
    public func fetchTasks() {
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
                    self.loading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No tasks found.")
                    self.loading = false
                    return
                }
                
                self.items = documents.map { doc in
                    let data = doc.data()
                    let id = doc.documentID
                    let title = data["title"] as? String ?? "Untitled Task"
                    let isCompleted = data["isCompleted"] as? Bool ?? false
                    return ItemModel(id: id, title: title, isCompleted: isCompleted)
                }
                .sorted { !$0.isCompleted && $1.isCompleted }
                
                self.loading = false
            }
    }
    
    
    func addItem(title: String) {
        let newItem: ItemModel = ItemModel(title: title, isCompleted: false)
        items.append(newItem)
        todoList.addItem(title)
    }
}

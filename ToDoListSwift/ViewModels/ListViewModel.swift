
import Foundation
import TodoListModule

class ListViewModel: ObservableObject {
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    @Published var searchText: String = ""
    let itemsKey: String = "items_list"
    var todoList: TodoList
    init() {
        self.todoList = TodoList()
        getItems()
    }
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
        self.items = savedItems
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
        for index in indexSet {
            let cppIndex = Int32(index)
            todoList.removeItem(cppIndex)
        }
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(title: String) {
        let newItem: ItemModel = ItemModel(title: title, isCompleted: false)
        items.append(newItem)
        todoList.addItem(title)
    }
    
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
            todoList.markCompleted(Int32(index))
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    var filteredItems: [ItemModel] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

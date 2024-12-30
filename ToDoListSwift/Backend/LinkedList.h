//
//  LinkedList.h
//  ToDoListSwift
//
//  Created by Hamza Wahab on 28/12/2024.
//

#ifndef LinkedList_h
#define LinkedList_h

#include "TodoItem.h"

struct Node {
    TodoItem data;
    Node* next;
    Node(TodoItem item) : data(item), next(nullptr) {}
};
class LinkedList {
    Node* head;
public:
    LinkedList() : head(nullptr) {}
    ~LinkedList();
    void addItem(const TodoItem& item);
    void removeItem(const int& id);
    TodoItem* findItem(const int& id);
    void displayItems() const;
};



#endif /* LinkedList_h */

//
//  TodoItem.h
//  ToDoListSwift
//
//  Created by Hamza Wahab on 28/12/2024.
//

#ifndef TodoItem_h
#define TodoItem_h

#include <string>

struct TodoItem {
    int id;
    const char* title;
    bool isCompleted;
    TodoItem(int id, const char* title, bool isCompleted = false)
        : id(id), title(title), isCompleted(isCompleted) {}
    TodoItem updateCompletion() const {
        return TodoItem(id, title, !isCompleted);
    }
};

#endif /* TodoItem_h */

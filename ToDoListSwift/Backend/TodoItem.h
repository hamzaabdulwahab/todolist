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

#endif 

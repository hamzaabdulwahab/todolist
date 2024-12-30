//
//  TodoList.h
//  ToDoListSwift
//
//  Created by Hamza Wahab on 28/12/2024.
//

#ifndef TodoList_h
#define TodoList_h

#include "LinkedList.h"
#include "Stack.h"
#include "Queue.h"
#include "UniqueIdGenerator.h"

class TodoList {
    LinkedList activeItems;
    Stack deletedItems;
    Queue completedItems;
public:
    void addItem(const char* title);
    void removeItem(const int& id);
    void markCompleted(const int& id);
    void restoreLastDeleted();
    void showActiveItems() const;
    void showCompletedItems() const;
};


#endif /* TodoList_h */

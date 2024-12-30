//
//  TodoList.cpp
//  ToDoListSwift
//
//  Created by Hamza Wahab on 28/12/2024.
//

#include <stdio.h>
#include "TodoList.h"
#include <iostream>
void TodoList::addItem(const char* title) {
    int id = UniqueIdGenerator::generateId();
    TodoItem item(id, title);
    activeItems.addItem(item);
}
void TodoList::removeItem(const int& id) {
    TodoItem* item = activeItems.findItem(id);
    if (item) {
        activeItems.removeItem(id);
        deletedItems.push(item);
    }
}
void TodoList::markCompleted(const int& id) {
    TodoItem* item = activeItems.findItem(id);
    if (item) {
        item->isCompleted = true;
        completedItems.enqueue(item);
    }
}
void TodoList::restoreLastDeleted() {
    TodoItem* item = deletedItems.pop();
    if (item) activeItems.addItem(*item);
}
void TodoList::showActiveItems() const {activeItems.displayItems();}

void TodoList::showCompletedItems() const {
    //completedItems.displayItems();
}

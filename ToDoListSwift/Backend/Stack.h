#ifndef STACK_H
#define STACK_H

#include "TodoItem.h"

class Stack {
    int capacity, top;
    TodoItem** items;
    void resize();
public:
    Stack(int initialCapacity = 100);
    ~Stack();
    void push(TodoItem* item);
    TodoItem* pop();
    bool isEmpty() const;
    int size() const;
};

#endif

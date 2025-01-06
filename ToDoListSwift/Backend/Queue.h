#ifndef Queue_h
#define Queue_h

#include "TodoItem.h"

class Queue {
    int capacity, front, rear, size;
    TodoItem** items;
    void resize();
public:
    Queue(int initialCapacity = 100);
    ~Queue();
    void enqueue(TodoItem* item);
    TodoItem* dequeue();
    bool isEmpty() const;
   // void displayItems() const;
    int getSize() const;
};

#endif 

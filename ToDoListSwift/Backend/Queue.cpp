#include "Queue.h"
#include <iostream>

Queue::Queue(int initialCapacity) : capacity(initialCapacity), front(-1), rear(1), size(0), items(new TodoItem*[capacity]){}
Queue::~Queue() {
    for (int i = 0; i < size; ++i) delete items[i];
    delete[] items;
}
void Queue::enqueue(TodoItem* item) {
    if (size == capacity) resize();
    if (front == -1) front = 0;
    rear = (rear + 1) % capacity;
    items[rear] = item;
    size++;
}
TodoItem* Queue::dequeue() {
    if (isEmpty()) return nullptr;
    TodoItem* dequeuedItem = items[front];
    if (front == rear) {
        front = rear = -1;
    }
    else front = (front + 1) % capacity;
    size--;
    return dequeuedItem;
}
bool Queue::isEmpty() const {return size == 0;}
int Queue::getSize() const {return size;}
void Queue::resize() {
    int newCapacity = capacity * 2;
    TodoItem** newItems = new TodoItem*[newCapacity];
    int i = front;
    for (int j = 0; j < size; ++j) {
        newItems[j] = items[i];
        i = (i + 1) % capacity;
    }
    delete[] items;
    items = newItems;
    front = 0;
    rear = size - 1;
    capacity = newCapacity;
}

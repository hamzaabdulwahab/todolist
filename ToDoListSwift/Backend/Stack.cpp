#include "Stack.h"
#include <iostream>

Stack::Stack(int initialCapacity) : capacity(initialCapacity), top(-1), items(new TodoItem*[capacity]){}
Stack::~Stack() {
    for (int i = 0; i <= top; ++i) delete items[i];
    delete[] items;
}

void Stack::push(TodoItem* item) {
    if (top >= capacity - 1) resize();
    items[++top] = item;
}
TodoItem* Stack::pop() {
    if (isEmpty()) return nullptr;
    return items[top--];
}
bool Stack::isEmpty() const {return top == -1;}
void Stack::resize() {
    capacity *= 2;
    TodoItem** newItems = new TodoItem*[capacity];
    for (int i = 0; i <= top; ++i) newItems[i] = items[i];
    delete[] items;
    items = newItems;
}
int Stack::size() const {return top + 1;}

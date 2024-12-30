//
//  LinkedList.cpp
//  ToDoListSwift
//
//  Created by Hamza Wahab on 28/12/2024.
//

#include "LinkedList.h"
#include <iostream>

LinkedList::~LinkedList() {
    Node* current = head;
    while (current) {
        Node* temp = current;
        current = current->next;
        delete temp;
    }
}
void LinkedList::addItem(const TodoItem& item) {
    Node* newNode = new Node(item);
    if (!head) head = newNode;
    else {
        Node* temp = head;
        while (temp->next) temp = temp->next;
        temp->next = newNode;
    }
}

void LinkedList::removeItem(const int& id) {
    Node* current = head;
    Node* prev = nullptr;
    while (current) {
        if (current->data.id == id) {
            if (prev) prev->next = current->next;
            else head = current->next;
            delete current;
            return;
        }
        prev = current;
        current = current->next;
    }
}

TodoItem* LinkedList::findItem(const int& id) {
    Node* current = head;
    while (current) {
        if (current->data.id == id) return &current->data;
        current = current->next;
    }
    return nullptr;
}

void LinkedList::displayItems() const {
    Node* current = head;
    while (current) {
        std::cout << "ID: " << current->data.id << ", Title: " << current->data.title
                  << ", Completed: " << (current->data.isCompleted ? "Yes" : "No") << "\n";
        current = current->next;
    }
}


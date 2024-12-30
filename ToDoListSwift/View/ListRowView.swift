//
//  ListRowView.swift
//  ToDoListSwift
//
//  Created by Hamza Wahab on 11/12/2024.
//

import SwiftUI
import TodoListModule

struct ListRowView: View {
    let item: ItemModel
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundStyle(item.isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }
        .font(.title3)
        .padding(.vertical, 3.5)
    }
}

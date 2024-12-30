//
//  ListView.swift
//  ToDoListSwift
//
//  Created by Hamza Wahab on 11/12/2024.
//

import SwiftUI
import TodoListModule

struct ListView: View {
    @State var name: String = ""
    @State var isShowingProfile = false
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.userSession != nil {
            VStack {
                ZStack {
                    if listViewModel.items.isEmpty {
                        NoItemsView()
                            .transition(AnyTransition.opacity.animation(.easeIn))
                    } else {
                        List {
                            ForEach(listViewModel.items) { item in
                                ListRowView(item: item)
                                    .onTapGesture {
                                        withAnimation(.linear) {
                                            listViewModel.updateItem(item: item)
                                        }
                                    }
                            }
                            .onDelete(perform: listViewModel.deleteItem)
                            .onMove(perform: listViewModel.moveItem)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .navigationTitle("Todo List 📝")
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: NavigationLink("Add", destination: AddView())
                )
                
                Spacer()
                HStack {
                    Spacer()
                    
                    Button {
                        isShowingProfile = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(size: 28))
                            .foregroundColor(Color(.systemGray))
                            .padding()
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingProfile, content: {
                ProfileView()

            })
        } else {
            LoginView()
        }
    }
}

#Preview {
    NavigationView {
        ListView()
    }
    .environmentObject(ListViewModel())
    .environmentObject(AuthViewModel())
}

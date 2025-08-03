import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ListView: View {
    @Environment(AuthViewModel.self) var authViewModel: AuthViewModel
    @Environment(ListViewModel.self) var listViewModel: ListViewModel
    
    
    var body: some View {
        Group {
            if authViewModel.userSession != nil {
                NavigationView {
                    VStack {
                        if listViewModel.loading {
                            ProgressView("Loading tasks...")
                        } else if listViewModel.items.isEmpty {
                            NoItemsView()
                                .transition(AnyTransition.opacity.animation(.easeIn))
                            
                        } else {
                            List {
                                ForEach(listViewModel.items) { item in
                                    ListRowView(item: item)
                                }
                                .onDelete(perform: listViewModel.deleteTask)
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    .onAppear {
                        listViewModel.fetchTasks()
                    }
                    .navigationTitle("My Tasks")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AddView()
                                .onDisappear {
                                    listViewModel.fetchTasks()
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.primary)
                                        .font(.title2)
                                        .padding(.top)
                                        .padding(.bottom)
                                }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink(destination: ProfileView()) {
                                Image(systemName: "person.circle")
                                    .foregroundColor(.primary)
                                    .font(.title2)
                                    .padding(.top)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
            } else {
                LoginView()
            }
        }
        .animation(.easeOut, value: authViewModel.userSession)
    }
    
    
    
}

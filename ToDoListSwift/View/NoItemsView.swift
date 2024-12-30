//
//  NoItemsView.swift
//  ToDoListSwift
//
//  Created by Hamza Wahab on 11/12/2024.
//

import SwiftUI

struct NoItemsView: View {
    @State var animate: Bool = false
    let secondaryStateColor = Color("SecondaryAccentColor")
    var body: some View {
        ScrollView{
            VStack(spacing: 10){
                Text("There are no items!")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("Ready to get things done? Add your first to-do and take the first step towards success.")
                    .padding(.bottom, 20)
                NavigationLink(destination: AddView()) {
                    Text("Add Something 🥳")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(animate ? secondaryStateColor : Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, animate ? 35 : 55)
                .shadow(color: animate ? secondaryStateColor.opacity(0.7) : Color.accentColor.opacity(0.7),
                        radius: animate ? 30 : 10,
                        x: 0,
                        y: animate ? 50 : 30)
                .scaleEffect(animate ? 1.1 : 1.0)
                .offset(y: animate ? -7 : 0)
            }
            .frame(maxWidth: 450)
            .multilineTextAlignment(.center)
            .padding(40)
            .onAppear(perform: addAnimation)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    func addAnimation(){
        guard !animate else {return}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
                
            ){
                animate.toggle()
            }
        }
    }
    
}

#Preview {
    NavigationView{
        NoItemsView()
        .navigationTitle("Title")
    }
}

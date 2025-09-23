//
//  HomeView.swift
//  AS#1
//
//  Created by 谢永杰 on 2025-09-22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var trip: Trip?
    
    var body: some View {
        NavigationStack {
            
            // APP Icon
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100,height: 100)
                    .foregroundStyle(.tint)
                
                Image(systemName: "mountain.2")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
            }
            
            Text("Welcome to Trip Planner")
                .font(.title2)
                .padding(.bottom,80)
                .padding(.top,20)
        
            NavigationLink(destination: AddTripView(tripInfo: $trip)) {
                Text("Add New Trip")
                    .frame(width: 230, height: 30)
                    .font(.headline)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(.tint)
                    .clipShape(Capsule())
            }
            
            NavigationLink(destination: TripDetailView(tripInfo: $trip)) {
                Text("View Trip")
                    .frame(width: 230, height: 30)
                    .font(.headline)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(.tint)
                    .clipShape(Capsule())
            }
            
        }
    }
}

#Preview {
    HomeView()
}

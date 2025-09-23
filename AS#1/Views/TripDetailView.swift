//
//  TripDetailView.swift
//  AS#1
//
//  Created by 谢永杰 on 2025-09-22.
//

import SwiftUI

struct TripDetailView: View {

    // get tripInfo from outside
    @Binding var tripInfo: Trip?

    // computed property
    var tripDuration: Int? {

        if let tripInfo = tripInfo {
            let calendar = Calendar.current
            let startOfStart = calendar.startOfDay(for: tripInfo.startDate)
            let startOfEnd = calendar.startOfDay(for: tripInfo.endDate)
            let components = calendar.dateComponents(
                [.day],
                from: startOfStart,
                to: startOfEnd
            )
            return components.day ?? 0
        } else {
            return nil
        }
    }

    var body: some View {

        if let tripInfo = tripInfo {
            if let assetImageName = tripInfo.assetImageName {
                Image(assetImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 300)
                    .clipped()
            }

            VStack {
                Text(tripInfo.title)
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.tint)
                    Text(tripInfo.location)
                }
                HStack {
                    Text(
                        tripInfo.startDate,
                        format: .dateTime.year().month().day()
                    )
                    Text("-")
                    Text(
                        tripInfo.endDate,
                        format: .dateTime.year().month().day()
                    )
                }
                .foregroundStyle(.secondary)
                .padding(.vertical,5)
                
                if let duration = tripDuration {
                    Text("Lasted for \(duration) Days")
                        .foregroundStyle(.secondary)
                }
                
                Text(tripInfo.notes)
                    .frame(maxWidth:.infinity,alignment: .topLeading)
                    .lineLimit(2)
                    .padding()

                Spacer()

            }

        } else {
            Text("No trip here")
                .font(.title2)
                .padding(20)
            NavigationLink("Add new trip") {
                AddTripView(tripInfo: $tripInfo)
            }
        }
    }
}

#Preview {
    TripDetailView(tripInfo: .constant(Trip(title: "Trip tp Japan", location: "Tokyo", startDate: Date(), endDate: Date(), notes: "", assetImageName: "tokyo")))
}

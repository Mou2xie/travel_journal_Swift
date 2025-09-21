//
//  ContentView.swift
//  AS#1
//
//  Created by 谢永杰 on 2025-09-18.
//

import SwiftUI

struct ContentView: View {

    //page states
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var notes: String = ""
    @State private var isAlerShow: Bool = false

    //to check if TextEditor is focused to display placeholder in note
    @FocusState private var isFocused: Bool

    //to decide whether to show error message
    @State private var isTitleError: Bool = false
    @State private var isLocationError: Bool = false
    @State private var isDateError: Bool = false

    //decide if save btn should be disabled
    private var saveBtnDisabled: Bool {
        if title.isEmpty || title.count < 2 || location.isEmpty
            || location.count < 2 || startDate > endDate || notes.count > 250
        {
            return true
        } else {
            return false
        }
    }

    //trip duration
    var daysBetween: Int {
        let calendar = Calendar.current
        let startOfStart = calendar.startOfDay(for: startDate)
        let startOfEnd = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents(
            [.day],
            from: startOfStart,
            to: startOfEnd
        )
        return components.day ?? 0
    }

    //check if endDate is greater or equals to startDate
    private func validateDate() {
        if startDate <= endDate {
            isDateError = false
        } else {
            isDateError = true
        }
    }

    //reset
    private func resetForm() {
        title = ""
        location = ""
        startDate = Date()
        endDate = Date()
        notes = ""
    }

    var body: some View {

        VStack {
            Text("Travel Journal")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.tint)

            Text("Enter trip details and save to preview in alert.")
                .foregroundStyle(.secondary)

            //Title
            TextField("Title", text: $title)
                .padding(20)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .onSubmit {
                    // form validation
                    if title.isEmpty || title.count < 2 {
                        isTitleError = true
                    } else {
                        isTitleError = false
                    }
                }

            if isTitleError {
                Text("Title should be at least 2 characters.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            //Location
            TextField("Location", text: $location)
                .padding(20)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .onSubmit {
                    // form validation
                    if location.isEmpty || location.count < 2 {
                        isLocationError = true
                    } else {
                        isLocationError = false
                    }
                }

            if isLocationError {
                Text("Location should be at least 2 characters.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Divider().padding(.vertical, 10)

            //StartDate
            DatePicker(
                "Start Date",
                selection: $startDate,
                in: Date()...,
                displayedComponents: [.date]
            )
            .padding(.vertical, 5)
            .onChange(of: startDate) {
                //validation
                validateDate()
            }

            //EndDate
            DatePicker(
                "End Date",
                selection: $endDate,
                in: Date()...,
                displayedComponents: [.date]
            )
            .padding(.vertical, 5)
            .onChange(of: endDate) {
                //validation
                validateDate()
            }

            if isDateError {
                Text("Start Date must be earlier than or equal to End Date.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Divider().padding(.vertical, 10)

            Text("Notes")
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack(alignment: .topLeading) {

                //Notes
                TextEditor(text: $notes)
                    .focused($isFocused)
                    .onChange(of: notes) { _, newValue in
                        //250 max input
                        if newValue.count > 250 {
                            notes = String(newValue.prefix(250))
                        }
                    }

                //show placeholder
                if notes.isEmpty && !isFocused {
                    Text("Enter notes here...")
                        .foregroundColor(.gray)
                }

            }
            .frame(height: 150)

            Text("\(notes.count) / 250")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.footnote)
                .foregroundStyle(notes.count >= 250 ? .red : .secondary)

            Spacer()

            Button("Save") {
                isAlerShow = true
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.tint)
            .foregroundColor(.white)
            .font(.title2)
            .clipShape(Capsule())
            .contentShape(Rectangle())
            .disabled(saveBtnDisabled)
            //alert
            .sheet(isPresented: $isAlerShow) {
                VStack(spacing: 10) {
                    Text("Trip Saved")
                        .font(.title2)
                        .font(.title)
                        .padding(.bottom, 20)
                    HStack {
                        Text("Title")
                        Spacer()
                        Text(title)
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Location")
                        Spacer()
                        Text(location)
                            .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Start Date")
                        Spacer()
                        Text(
                            startDate,
                            format: .dateTime.year().month().day()
                        )
                        .fontWeight(.semibold)
                    }
                    HStack {
                        Text("End Date")
                        Spacer()
                        Text(
                            endDate,
                            format: .dateTime.year().month().day()
                        )
                        .fontWeight(.semibold)
                    }
                    HStack {
                        Text("Trip Duration ")
                        Spacer()
                        Text("\(daysBetween) Days")
                            .fontWeight(.semibold)
                    }
                    Text("Notes")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(notes.count > 150 ? notes.prefix(150) + "..." : notes)
                }
                .padding(40)
                Button("Close") {
                    isAlerShow = false
                }
            }

            Button("Reset") {
                resetForm()
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(.tint)
            .foregroundColor(.white)
            .font(.title2)
            .clipShape(Capsule())
            .contentShape(Rectangle())
        }
        .padding(20)
    }
}

#Preview {
    ContentView()
}

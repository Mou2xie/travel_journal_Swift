//
//  ContentView.swift
//  AS#1
//
//  Created by 谢永杰 on 2025-09-18.
//

import SwiftUI

struct AddTripView: View {
    
    @Binding var tripInfo: Trip?
    
    @Environment(\.dismiss) var dissmiss

    private let imagesList = ["none", "china", "tokyo", "moscow"]

    // Local state variables for form data
    @State private var title: String = ""
    @State private var location: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var notes: String = ""
    @State private var selectedImage: String = "none"

    //to check if TextEditor is focused to display placeholder in note
    @FocusState private var isFocused: Bool
    //to decide whether to show error message
    @State private var isTitleError: Bool = false
    @State private var isLocationError: Bool = false
    @State private var isDateError: Bool = false

    //decide if save btn should be disabled
    private var saveBtnDisabled: Bool {
        if title.isEmpty || title.count < 2 || location.isEmpty
            || location.count < 2 || startDate > endDate || notes.count > 120
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

    var body: some View {
        VStack {
                Text("Add a Trip")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tint)

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
                            //120 max input
                            if newValue.count > 120 {
                                notes = String(newValue.prefix(120))
                            }
                        }

                    //show placeholder
                    if notes.isEmpty && !isFocused {
                        Text("Enter notes here...")
                            .foregroundColor(.gray)
                    }

                }
                .frame(height: 50)

                Text("\(notes.count) / 120")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.footnote)
                    .foregroundStyle(notes.count >= 120 ? .red : .secondary)

                Divider().padding(.vertical, 10)

                HStack {
                    Text("Select a Image")
                    Spacer()
                    Picker("select a image", selection: $selectedImage) {
                        ForEach(imagesList, id: \.self) { item in
                            HStack {
                                Text(item.capitalized).tag(item)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                }

                if selectedImage != "none" {

                    HStack {
                        Image(selectedImage)
                            .resizable()
                            .frame(width: 90, height: 90)
                            .cornerRadius(10)
                            .padding(5)
                        Spacer()
                    }
                }

                Spacer()

                Button("Save") {
                    // Create new trip with form data
                    let newTrip = Trip(
                        title: title,
                        location: location,
                        startDate: startDate,
                        endDate: endDate,
                        notes: notes,
                        assetImageName: selectedImage != "none" ? selectedImage : nil
                    )
                    // Update the binding
                    tripInfo = newTrip
                    // Dismiss the view
                    dissmiss()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.tint)
                .foregroundColor(.white)
                .font(.title2)
                .clipShape(Capsule())
                .contentShape(Rectangle())
                .disabled(saveBtnDisabled)

                Button("Cancel") {
                    dissmiss()
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
            .onAppear {
                // Initialize form data if editing existing trip
                if let tripInfo = tripInfo {
                    title = tripInfo.title
                    location = tripInfo.location
                    startDate = tripInfo.startDate
                    endDate = tripInfo.endDate
                    notes = tripInfo.notes
                    selectedImage = tripInfo.assetImageName ?? "none"
                }
            }
    }
}

#Preview {
    AddTripView(tripInfo: .constant(nil))
}

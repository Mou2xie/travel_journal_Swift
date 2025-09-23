# Travel Journal - SwiftUI App

Mobile Application Development II
Yongjie Xie
Github:https://github.com/Mou2xie/travel_journal_Swift

## Input Validation Logic Implementation

### 1. Form Validation State Management
Using `@State` to manage error states:
```swift
@State private var isTitleError: Bool = false
@State private var isLocationError: Bool = false
@State private var isDateError: Bool = false
```

### 2. Real-time Input Validation
- **Title and Location Validation**: Uses `.onSubmit` modifier to check character length
- **Date Validation**: Uses `.onChange` modifier to real-time check if start date is earlier than end date
- **Notes Character Limit**: Limits maximum 250 characters in `.onChange`

### 3. Save Button Disable Logic
Computed property `saveBtnDisabled` checks all validation conditions:
```swift
private var saveBtnDisabled: Bool {
    if title.isEmpty || title.count < 2 || location.isEmpty
        || location.count < 2 || startDate > endDate || notes.count > 250
    {
        return true
    } else {
        return false
    }
}
```

## Modal Implementation

### Sheet Modal
Uses SwiftUI's `.sheet` modifier to display trip details preview:

```swift
.sheet(isPresented: $isAlerShow) {
    VStack(spacing: 10) {
        Text("Trip Saved")
        // Display all trip information
        HStack {
            Text("Title")
            Spacer()
            Text(title).fontWeight(.semibold)
        }
        // ... other information display
    }
    .padding(40)
    Button("Close") {
        isAlerShow = false
    }
}
```

### Trigger Mechanism
Clicking the "Save" button sets `isAlerShow = true` to trigger modal display.

## Key Features
- Form input and real-time validation
- Automatic trip duration calculation
- Sheet modal preview
- Form reset functionality

## @Binding Implementation for State Synchronization Across Multiple Screens

### Project Architecture Overview
This project demonstrates how to use `@Binding` to maintain a single source of truth for trip data across three main views: `HomeView`, `AddTripView`, and `TripDetailView`.

### State Management Implementation

#### 1. Central State Definition in HomeView
The `HomeView` serves as the parent container that holds the central state:

```swift
struct HomeView: View {
    @State private var trip: Trip?  // Single source of truth

    var body: some View {
        NavigationStack {
            // Pass binding to child views
            NavigationLink(destination: AddTripView(tripInfo: $trip)) {
                Text("Add New Trip")
            }

            NavigationLink(destination: TripDetailView(tripInfo: $trip)) {
                Text("View Trip")
            }
        }
    }
}
```

#### 2. Data Binding in AddTripView
The `AddTripView` receives and modifies the trip data through binding:

```swift
struct AddTripView: View {
    @Binding var tripInfo: Trip?  // Receives binding from HomeView
    @Environment(\.dismiss) var dismiss

    // Local state for form inputs
    @State private var title: String = ""
    @State private var location: String = ""
    // ... other form fields

    // Save button updates the binding
    Button("Save") {
        let newTrip = Trip(
            title: title,
            location: location,
            startDate: startDate,
            endDate: endDate,
            notes: notes,
            assetImageName: selectedImage != "none" ? selectedImage : nil
        )
        tripInfo = newTrip  // Updates parent view's state
        dismiss()           // Returns to previous view
    }
}
```

#### 3. Data Display in TripDetailView
The `TripDetailView` reads the trip data through binding and displays it:

```swift
struct TripDetailView: View {
    @Binding var tripInfo: Trip?  // Receives binding from HomeView

    var body: some View {
        if let tripInfo = tripInfo {
            // Display trip information
            VStack {
                Text(tripInfo.title)
                Text(tripInfo.location)
                // Computed property using bound data
                Text("Lasted for \(tripDuration) Days")
            }
        } else {
            Text("No trip here")
            NavigationLink("Add new trip") {
                AddTripView(tripInfo: $tripInfo)  // Pass binding
            }
        }
    }
}
```

### Key Benefits of This @Binding Implementation

1. **Single Source of Truth**: All views share the same `Trip?` instance from `HomeView`
2. **Automatic UI Updates**: When `AddTripView` saves a trip, `TripDetailView` immediately shows the new data
3. **Bidirectional Data Flow**: Changes in any view automatically propagate to all connected views
4. **Simplified State Management**: No need for complex data passing or callback functions

## Multi-Screen Navigation Implementation

### NavigationStack Architecture
The project uses `NavigationStack` (iOS 16+) for modern navigation management:

```swift
struct HomeView: View {
    var body: some View {
        NavigationStack {
            // Navigation buttons with declarative destinations
            NavigationLink(destination: AddTripView(tripInfo: $trip)) {
                Text("Add New Trip")
            }

            NavigationLink(destination: TripDetailView(tripInfo: $trip)) {
                Text("View Trip")
            }
        }
    }
}
```

### Environment-Based Navigation Dismissal
Using `@Environment(\.dismiss)` for programmatic navigation control:

```swift
struct AddTripView: View {
    @Environment(\.dismiss) var dismiss  // Access to dismiss function

    var body: some View {
        VStack {
            // Form content

            Button("Save") {
                // Save logic
                tripInfo = newTrip
                dismiss()  // Navigate back to previous view
            }

            Button("Cancel") {
                dismiss()  // Navigate back without saving
            }
        }
    }
}
```

### Conditional Navigation Flow
The `TripDetailView` implements conditional navigation based on data state:

```swift
struct TripDetailView: View {
    @Binding var tripInfo: Trip?

    var body: some View {
        if let tripInfo = tripInfo {
            // Display trip details when data exists
            VStack {
                Text(tripInfo.title)
                // ... trip information display
            }
        } else {
            // Show "Add Trip" option when no data exists
            Text("No trip here")
            NavigationLink("Add new trip") {
                AddTripView(tripInfo: $tripInfo)
            }
        }
    }
}
```

### Navigation Flow Summary
1. **HomeView → AddTripView**: User creates new trip
2. **AddTripView → HomeView**: User saves/cancels, returns via `dismiss()`
3. **HomeView → TripDetailView**: User views trip details
4. **TripDetailView → AddTripView**: User can add trip if none exists
5. **Data Persistence**: All navigation preserves state through `@Binding`

This navigation pattern ensures seamless data flow while maintaining clean separation of concerns between views.

